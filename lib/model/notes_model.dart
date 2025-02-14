class Note {
  String id;
  String title;
  String subtitle;
  String time;
  int image;
  bool isDone;

  Note({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.image,
    required this.isDone,
  });

// Konversi dari Map (Firestore) ke Objek Note
  factory Note.fromMap(Map<String, dynamic> data) {
    return Note(
      id: data['id'] as String,
      subtitle: data['subtitle'] as String,
      title: data['title'] as String,
      time: data['time'] as String,
      image: data['image'] as int,
      isDone: data['isDone'] as bool,
    );
  }

  // Konversi dari Objek Note ke Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subtitle': subtitle,
      'title': title,
      'time': time,
      'image': image,
      'isDone': isDone,
    };
  }
}
