import 'dart:convert';
import 'dart:typed_data';

import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campusflow/core/network/dio_client.dart';
import 'package:campusflow/data/repositories/api_task_repository.dart';
import 'package:campusflow/data/repositories/fake_task_repository.dart';

/// Faux adaptateur HTTP : enregistre les requêtes et renvoie une réponse fixe.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.status, this.body);

  final int status;
  final Object? body;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dio(_FakeAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter;

void main() {
  group('ApiTaskRepository', () {
    test('GET /taches et conversion avec fromJson', () async {
      final adapter = _FakeAdapter(200, [
        {
          'id': 1,
          'title': 'Quiz Dart',
          'courseId': 'mobile',
          'dueDate': '2026-12-03T10:00:00',
          'done': false,
        },
      ]);

      final tasks = await ApiTaskRepository(_dio(adapter)).fetchAll();

      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.path, '/taches');
      expect(tasks.single.id, '1');
      expect(tasks.single.title, 'Quiz Dart');
    });

    test('PATCH /taches/:id pour cocher une tâche', () async {
      final adapter = _FakeAdapter(200, {
        'id': 4,
        'title': 'Quiz Dart',
        'courseId': 'mobile',
        'dueDate': '2026-12-03T10:00:00',
        'done': true,
      });

      final task = await ApiTaskRepository(
        _dio(adapter),
      ).setDone('4', done: true);

      expect(adapter.requests.single.method, 'PATCH');
      expect(adapter.requests.single.path, '/taches/4');
      expect(adapter.requests.single.data, {'done': true});
      expect(task.done, isTrue);
    });

    test('une erreur HTTP devient une ApiException lisible', () async {
      final adapter = _FakeAdapter(500, {'error': 'boom'});

      await expectLater(
        ApiTaskRepository(_dio(adapter)).fetchAll(),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });
  });

  group('FakeTaskRepository', () {
    test('création, cochage et suppression en mémoire', () async {
      final repository = FakeTaskRepository(initial: const []);

      final created = await repository.create(
        Task(
          id: '',
          title: 'Fiche de lecture',
          courseId: 'projet',
          dueDate: DateTime(2026, 12, 1),
        ),
      );
      expect(created.id, isNotEmpty);

      await repository.setDone(created.id, done: true);
      expect((await repository.fetchAll()).single.done, isTrue);

      await repository.delete(created.id);
      expect(await repository.fetchAll(), isEmpty);
    });
  });
}
