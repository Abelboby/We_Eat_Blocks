import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import '../../../theme/app_theme.dart';
import '../../../theme/theme_provider.dart';
import '../../../services/auth_provider.dart';
import '../../../providers/events_provider.dart';
import '../../../models/cleanup_event_model.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxVolunteersController = TextEditingController();
  final _equipmentController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 12, minute: 0);
  final List<String> _equipmentNeeded = [];
  bool _isLoading = false;

  // Mock coordinates since we don't have a map integration yet
  // In a real app, you would use a map picker to select coordinates
  final GeoPoint _defaultCoordinates = const GeoPoint(37.7749, -122.4194);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxVolunteersController.dispose();
    _equipmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final currentUser = Provider.of<AuthProvider>(context).currentUser;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
                    AppTheme.primaryDark,
                    AppTheme.secondaryDark,
                  ]
                : [
                    AppTheme.lightBackground,
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: const Text('Host Cleanup Event'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPremiumCard(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(
                                  icon: Icons.eco,
                                  title: 'Event Details',
                                  isDarkMode: isDarkMode,
                                ),
                                const SizedBox(height: 16),

                                // Title Field
                                TextFormField(
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                    labelText: 'Event Title',
                                    hintText:
                                        'e.g., Beach Cleanup at Golden Gate',
                                    prefixIcon: Icon(
                                      Icons.title,
                                      color: AppTheme.accentTeal,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an event title';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Description Field
                                TextFormField(
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    labelText: 'Description',
                                    hintText: 'Describe the cleanup event...',
                                    prefixIcon: Icon(
                                      Icons.description,
                                      color: AppTheme.accentTeal,
                                    ),
                                    alignLabelWithHint: true,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a description';
                                    }
                                    return null;
                                  },
                                  maxLines: 3,
                                ),

                                const SizedBox(height: 16),

                                // Location Field
                                TextFormField(
                                  controller: _locationController,
                                  decoration: InputDecoration(
                                    labelText: 'Location',
                                    hintText:
                                        'e.g., Baker Beach, San Francisco',
                                    prefixIcon: Icon(
                                      Icons.location_on,
                                      color: AppTheme.accentTeal,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a location';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          isDarkMode: isDarkMode,
                        ),

                        const SizedBox(height: 20),

                        // Date and Time Card
                        _buildPremiumCard(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(
                                  icon: Icons.calendar_today,
                                  title: 'Date & Time',
                                  isDarkMode: isDarkMode,
                                ),
                                const SizedBox(height: 16),

                                // Date Picker
                                ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          AppTheme.accentTeal.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.event,
                                      color: AppTheme.accentTeal,
                                    ),
                                  ),
                                  title: const Text('Event Date'),
                                  subtitle: Text(
                                    DateFormat('EEEE, MMM d, yyyy')
                                        .format(_selectedDate),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? AppTheme.textPrimary
                                          : AppTheme.textPrimaryLight,
                                    ),
                                  ),
                                  onTap: () => _selectDate(context),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: isDarkMode
                                        ? AppTheme.textSecondary
                                        : AppTheme.textSecondaryLight,
                                  ),
                                ),

                                const Divider(),

                                // Start Time Picker
                                ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          AppTheme.accentTeal.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.access_time,
                                      color: AppTheme.accentTeal,
                                    ),
                                  ),
                                  title: const Text('Start Time'),
                                  subtitle: Text(
                                    _startTime.format(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? AppTheme.textPrimary
                                          : AppTheme.textPrimaryLight,
                                    ),
                                  ),
                                  onTap: () => _selectStartTime(context),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: isDarkMode
                                        ? AppTheme.textSecondary
                                        : AppTheme.textSecondaryLight,
                                  ),
                                ),

                                const Divider(),

                                // End Time Picker
                                ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          AppTheme.accentTeal.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.access_time,
                                      color: AppTheme.accentTeal,
                                    ),
                                  ),
                                  title: const Text('End Time'),
                                  subtitle: Text(
                                    _endTime.format(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? AppTheme.textPrimary
                                          : AppTheme.textPrimaryLight,
                                    ),
                                  ),
                                  onTap: () => _selectEndTime(context),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: isDarkMode
                                        ? AppTheme.textSecondary
                                        : AppTheme.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isDarkMode: isDarkMode,
                        ),

                        const SizedBox(height: 20),

                        // Volunteers and Equipment Card
                        _buildPremiumCard(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(
                                  icon: Icons.people,
                                  title: 'Volunteers & Equipment',
                                  isDarkMode: isDarkMode,
                                ),
                                const SizedBox(height: 16),

                                // Max Volunteers Field
                                TextFormField(
                                  controller: _maxVolunteersController,
                                  decoration: InputDecoration(
                                    labelText: 'Maximum Volunteers',
                                    hintText: 'e.g., 20',
                                    prefixIcon: Icon(
                                      Icons.group,
                                      color: AppTheme.accentTeal,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter maximum volunteers';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 24),

                                // Equipment Needed Section
                                Text(
                                  'Equipment Needed',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? AppTheme.textPrimary
                                        : AppTheme.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Equipment List
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: _equipmentController,
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Add equipment (e.g., gloves, bags)',
                                              prefixIcon: Icon(
                                                Icons.handyman,
                                                color: AppTheme.accentTeal,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: _addEquipment,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppTheme.accentTeal,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Add'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    if (_equipmentNeeded.isEmpty)
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? Colors.grey.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'No equipment added yet',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: _equipmentNeeded.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            margin: const EdgeInsets.only(
                                                bottom: 8),
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.construction,
                                                color: AppTheme.accentTeal,
                                              ),
                                              title:
                                                  Text(_equipmentNeeded[index]),
                                              trailing: IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  setState(() {
                                                    _equipmentNeeded
                                                        .removeAt(index);
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          isDarkMode: isDarkMode,
                        ),

                        const SizedBox(height: 30),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: _buildPremiumActionButton(
                            icon: Icons.add_circle_outline,
                            label: 'Create Cleanup Event',
                            color: AppTheme.accentTeal,
                            isDarkMode: isDarkMode,
                            isFilled: true,
                            isWide: true,
                            onPressed: () => _submitForm(currentUser),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.accentTeal,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.accentTeal,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
        // If end time is earlier than start time, update end time
        if (_timeOfDayToDouble(_endTime) <= _timeOfDayToDouble(_startTime)) {
          _endTime = TimeOfDay(
            hour: (_startTime.hour + 3) % 24,
            minute: _startTime.minute,
          );
        }
      });
    }
  }

  void _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.accentTeal,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _endTime) {
      // Check if end time is after start time
      if (_timeOfDayToDouble(picked) > _timeOfDayToDouble(_startTime)) {
        setState(() {
          _endTime = picked;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be after start time'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  double _timeOfDayToDouble(TimeOfDay time) {
    return time.hour + time.minute / 60.0;
  }

  void _addEquipment() {
    final equipment = _equipmentController.text.trim();
    if (equipment.isNotEmpty) {
      setState(() {
        _equipmentNeeded.add(equipment);
        _equipmentController.clear();
      });
    }
  }

  void _submitForm(dynamic currentUser) async {
    if (_formKey.currentState!.validate()) {
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be logged in to create an event'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Combine date and time for start and end times
        final startDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _startTime.hour,
          _startTime.minute,
        );

        final endDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _endTime.hour,
          _endTime.minute,
        );

        final eventData = {
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'organizerId': currentUser.id,
          'organizerName': currentUser.displayName ?? 'Anonymous',
          'location': _locationController.text.trim(),
          'coordinates': _defaultCoordinates,
          'date': Timestamp.fromDate(_selectedDate),
          'startTime': Timestamp.fromDate(startDateTime),
          'endTime': Timestamp.fromDate(endDateTime),
          'maxVolunteers': int.parse(_maxVolunteersController.text.trim()),
          'volunteerIds': [],
          'equipmentNeeded': _equipmentNeeded,
          'status': 'upcoming',
        };

        final eventsProvider =
            Provider.of<EventsProvider>(context, listen: false);
        final newEvent = await eventsProvider.createEvent(eventData);

        if (newEvent != null) {
          if (mounted) {
            Navigator.of(context).pop(true); // Pop and return success
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(eventsProvider.error ?? 'Failed to create event'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Widget _buildPremiumCard({
    required Widget child,
    required bool isDarkMode,
    List<Color>? gradientColors,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDarkMode
                  ? AppTheme.secondaryDark.withOpacity(0.7)
                  : Colors.white.withOpacity(0.8),
              gradient: gradientColors != null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    )
                  : null,
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.8),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDarkMode
              ? AppTheme.accentTeal
              : AppTheme.primaryDark.withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:
                isDarkMode ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    required bool isDarkMode,
    bool isFilled = false,
    bool isWide = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            gradient: isFilled
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color,
                      color.withOpacity(0.8),
                    ],
                  )
                : null,
            color: isFilled
                ? null
                : isDarkMode
                    ? AppTheme.secondaryDark
                    : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(isFilled ? 0.3 : 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
            border: isFilled
                ? null
                : Border.all(
                    color: color.withOpacity(0.5),
                    width: 1.5,
                  ),
          ),
          child: Container(
            width: isWide ? double.infinity : null,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isWide ? 18 : 14,
            ),
            child: _isLoading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: isWide ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: isWide
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Icon(
                        icon,
                        color: isFilled ? Colors.white : color,
                        size: 20,
                      ),
                      SizedBox(width: isWide ? 12 : 8),
                      Text(
                        label,
                        style: TextStyle(
                          color: isFilled ? Colors.white : color,
                          fontWeight: FontWeight.w600,
                          fontSize: isWide ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
