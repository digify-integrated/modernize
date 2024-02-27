function showErrorDialog(error){
    document.getElementById("error-dialog").innerHTML = error;
    $('#system-error-modal').modal('show');
}