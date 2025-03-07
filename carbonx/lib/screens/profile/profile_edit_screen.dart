import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart'; // Uncomment when available
import 'package:firebase_storage/firebase_storage.dart';
import '../../services/auth_provider.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';
import '../../core/utils/url_launcher_utils.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasChanges = false;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final userService = Provider.of<UserService>(context, listen: false);
      final userId = userService.currentUserId;

      if (userId != null) {
        final user = await userService.getUserFromFirestore(userId);

        if (user != null && mounted) {
          setState(() {
            _user = user;
            _nameController.text = user.displayName ?? '';
            _bioController.text = user.bio ?? '';
          });
        }
      }
    } catch (e) {
      _setError('Failed to load profile data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _setError(String message) {
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _pickImage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image picking functionality will be available soon'),
        backgroundColor: Colors.orange,
      ),
    );

    /* Uncomment when image_picker is available
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _hasChanges = true;
        });
      }
    } catch (e) {
      _setError('Error selecting image: $e');
    }
    */
  }

  Future<String?> _uploadImage(String userId) async {
    if (_imageFile == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profile_images')
          .child('$userId.jpg');

      final uploadTask = storageRef.putFile(
        _imageFile!,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_hasChanges) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userService = Provider.of<UserService>(context, listen: false);
      final userId = userService.currentUserId;

      if (userId == null) {
        _setError('User not authenticated');
        return;
      }

      final Map<String, dynamic> updates = {
        'displayName': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
      };

      // Upload image if selected
      if (_imageFile != null) {
        final imageUrl = await _uploadImage(userId);
        if (imageUrl != null) {
          updates['photoUrl'] = imageUrl;
        }
      }

      await userService.updateUserData(userId, updates);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(
            context, true); // Return true to indicate changes were made
      }
    } catch (e) {
      _setError('Failed to update profile: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'Save',
              style: TextStyle(
                color:
                    _hasChanges ? Theme.of(context).primaryColor : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading && _user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                onChanged: () {
                  if (!_hasChanges) {
                    setState(() => _hasChanges = true);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfileImagePicker(),
                    const SizedBox(height: 24),
                    _buildNameField(),
                    const SizedBox(height: 16),
                    _buildBioField(),
                    const SizedBox(height: 24),
                    _buildWalletSection(),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _imageFile != null
                ? FileImage(_imageFile!) as ImageProvider
                : (_user?.photoUrl != null
                    ? NetworkImage(_user!.photoUrl!) as ImageProvider
                    : const AssetImage('assets/images/default_avatar.png')),
            child: _user?.photoUrl == null && _imageFile == null
                ? const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey,
                  )
                : null,
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Display Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a display name';
        }
        return null;
      },
    );
  }

  Widget _buildBioField() {
    return TextFormField(
      controller: _bioController,
      decoration: const InputDecoration(
        labelText: 'Bio',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
        hintText: 'Tell us about yourself...',
      ),
      maxLines: 3,
    );
  }

  Widget _buildWalletSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance_wallet, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Connected Wallet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_user?.hasWallet ?? false) ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatWalletAddress(_user?.walletAddress),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Connected on ${_formatDate(_user?.walletConnectedAt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.launch, size: 20),
                    onPressed: () {
                      if (_user?.walletAddress != null) {
                        UrlLauncherUtils.openWalletExplorer(
                          _user!.walletAddress!,
                          context: context,
                        );
                      }
                    },
                    tooltip: 'View on Explorer',
                  ),
                ],
              ),
            ] else ...[
              const Text(
                'No wallet connected',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to wallet tab
                  Navigator.pop(context);
                  if (context.mounted) {
                    final homeState =
                        context.findAncestorStateOfType<_HomeScreenState>();
                    if (homeState != null) {
                      homeState._onItemTapped(3); // Index 3 is the wallet tab
                    }
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Connect Wallet'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatWalletAddress(String? address) {
    if (address == null || address.isEmpty) {
      return 'No address';
    }

    if (address.length > 10) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
    }

    return address;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'unknown date';

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}

// Placeholder for HomeScreenState access
class _HomeScreenState extends State<StatefulWidget> {
  void _onItemTapped(int index) {}

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
