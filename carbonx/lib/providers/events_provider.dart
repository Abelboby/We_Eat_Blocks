import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cleanup_event_model.dart';

class EventsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CleanUpEvent> _events = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<CleanUpEvent> get events => _events;
  List<CleanUpEvent> get upcomingEvents =>
      _events.where((event) => event.isUpcoming).toList();
  List<CleanUpEvent> get ongoingEvents =>
      _events.where((event) => event.isOngoing).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  // CRUD Operations
  Future<void> fetchEvents() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final querySnapshot = await _firestore
          .collection('events')
          .orderBy('date', descending: false)
          .get();

      _events = querySnapshot.docs
          .map((doc) => CleanUpEvent.fromFirestore(doc))
          .toList();
    } catch (e) {
      _error = 'Failed to fetch events: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CleanUpEvent?> createEvent(Map<String, dynamic> eventData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Add timestamps
      eventData['createdAt'] = FieldValue.serverTimestamp();
      eventData['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _firestore.collection('events').add(eventData);

      // Get the document to return the created event with the ID
      final docSnapshot = await docRef.get();
      final newEvent = CleanUpEvent.fromFirestore(docSnapshot);

      // Add to local events list and notify
      _events.add(newEvent);

      return newEvent;
    } catch (e) {
      _error = 'Failed to create event: $e';
      debugPrint(_error);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> joinEvent(String eventId, String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('events').doc(eventId).update({
        'volunteerIds': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local events list
      final index = _events.indexWhere((event) => event.id == eventId);
      if (index != -1) {
        final event = _events[index];
        if (!event.volunteerIds.contains(userId)) {
          final updatedVolunteerIds = List<String>.from(event.volunteerIds)
            ..add(userId);
          final updatedEvent = CleanUpEvent(
            id: event.id,
            title: event.title,
            description: event.description,
            organizerId: event.organizerId,
            organizerName: event.organizerName,
            location: event.location,
            coordinates: event.coordinates,
            date: event.date,
            startTime: event.startTime,
            endTime: event.endTime,
            maxVolunteers: event.maxVolunteers,
            volunteerIds: updatedVolunteerIds,
            equipmentNeeded: event.equipmentNeeded,
            status: event.status,
            createdAt: event.createdAt,
            updatedAt: DateTime.now(),
          );
          _events[index] = updatedEvent;
        }
      }

      return true;
    } catch (e) {
      _error = 'Failed to join event: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> leaveEvent(String eventId, String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('events').doc(eventId).update({
        'volunteerIds': FieldValue.arrayRemove([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local events list
      final index = _events.indexWhere((event) => event.id == eventId);
      if (index != -1) {
        final event = _events[index];
        if (event.volunteerIds.contains(userId)) {
          final updatedVolunteerIds = List<String>.from(event.volunteerIds)
            ..remove(userId);
          final updatedEvent = CleanUpEvent(
            id: event.id,
            title: event.title,
            description: event.description,
            organizerId: event.organizerId,
            organizerName: event.organizerName,
            location: event.location,
            coordinates: event.coordinates,
            date: event.date,
            startTime: event.startTime,
            endTime: event.endTime,
            maxVolunteers: event.maxVolunteers,
            volunteerIds: updatedVolunteerIds,
            equipmentNeeded: event.equipmentNeeded,
            status: event.status,
            createdAt: event.createdAt,
            updatedAt: DateTime.now(),
          );
          _events[index] = updatedEvent;
        }
      }

      return true;
    } catch (e) {
      _error = 'Failed to leave event: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateEventStatus(String eventId, String status) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('events').doc(eventId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local events list
      final index = _events.indexWhere((event) => event.id == eventId);
      if (index != -1) {
        final event = _events[index];
        final updatedEvent = CleanUpEvent(
          id: event.id,
          title: event.title,
          description: event.description,
          organizerId: event.organizerId,
          organizerName: event.organizerName,
          location: event.location,
          coordinates: event.coordinates,
          date: event.date,
          startTime: event.startTime,
          endTime: event.endTime,
          maxVolunteers: event.maxVolunteers,
          volunteerIds: event.volunteerIds,
          equipmentNeeded: event.equipmentNeeded,
          status: status,
          createdAt: event.createdAt,
          updatedAt: DateTime.now(),
        );
        _events[index] = updatedEvent;
      }

      return true;
    } catch (e) {
      _error = 'Failed to update event status: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
