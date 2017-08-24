import 'package:fo_components/fo_components.dart';

class Status extends DataTableModel
{
  Status(this._name, String id) : super(id);

  String get name => _name;

  @override
  String toString() => _name;

  final String _name;
}