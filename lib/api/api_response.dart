class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;

  ApiResponse.loading(this.message){
    status = Status.loading;
  }

  ApiResponse.completed(this.data) {
    status = Status.complete;
  }

  ApiResponse.error(this.message) {
    status = Status.error;
  }

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { loading, complete, error }
