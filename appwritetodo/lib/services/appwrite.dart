import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AppwriteServices {
  late Client client;
  late Databases databases;
  static const endpoint = "https://cloud.appwrite.io/v1";
  static const projectId = "674065a6003a2906a5c1";
  static const databaseId = "6740668d000629c46dea";
  static const collectionId = "674066e10003a3fcd860";

  AppwriteServices() {
    client = Client();
    client.setEndpoint(endpoint);
    client.setProject(projectId);
    databases = Databases(client);
  }

  Future<Document> addtask(_task) async {
    try {
      final documentId = ID.unique();
      print(documentId);

      final result = databases.createDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: documentId,
          data: {"taskk": _task, "isComplete": false});
      return result;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Document>> getTask() async {
    try {
      final result = await databases.listDocuments(
          databaseId: databaseId, collectionId: collectionId);
      print("================================== appservice");
      print(result);
      print("================================== appservice");
      return result.documents;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> delete(String DocumentId) async {
    try {
      final result = await databases.deleteDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: DocumentId);
    } catch (e) {
      print(e);
    }
  }

  Future<Document> updateTaskstatus(String documentId, bool completed) async {
    try {
      final result = await databases.updateDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: documentId,
          data: {"isComplete": completed});
          return result;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
