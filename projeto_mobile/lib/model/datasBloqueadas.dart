// ignore: file_names
class DataBloqueada{
  String id = "";
  String data = "";

  DataBloqueada(this.data);

  setId(String id){
    this.id = id;
  }

  setData(String data){
    this.data = data;
  }

  toMap() {
    return {
      "id": id,
      "data": data,
    };
  }
}