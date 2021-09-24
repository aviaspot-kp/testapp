class Queries {
  String createCacheTable = '''
    CREATE TABLE IF NOT EXISTS cache (
      id INTEGER PRIMARY KEY,
      name TEXT,
      doc_id TEXT
      );
      ''';

  String dropCacheTable = 'DROP TABLE cache';
}
