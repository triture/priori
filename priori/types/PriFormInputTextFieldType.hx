package priori.types;

@:enum
abstract PriFormInputTextFieldType(String) {
    var TEXT = "text";
    var EMAIL = "email";
    var PASSWORD = "password";
    var NUMBER = "number";
    var DATE = "date";
}
