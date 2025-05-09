import 'package:flutter/material.dart';

class AccountTable extends StatelessWidget {
  const AccountTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.3),
        1: FlexColumnWidth(0.4),
        2: FlexColumnWidth(1),
      },

      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _buildHeaderRow(),
        _buildDataRow("Your name is shown to others", true, true, context),
        _buildDataRow("Full privacy features", false, true, context),
        _buildDataRow("Priority support", true, true, context),
      ],
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      children: [
        _headerText('Features'),
        _headerText('Free'),
        _headerText('Anonymous'),
      ],
    );
  }

  TableRow _buildDataRow(
    String feature,
    bool free,
    bool anonymous,
    BuildContext context,
  ) {
    return TableRow(
      children: [
        _cellText(feature),
        _centeredIcon(free, context),
        _centeredIcon(anonymous, context),
      ],
    );
  }

  Widget _headerText(String text, {bool center = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        textAlign: center ? TextAlign.center : TextAlign.left,
        text,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 12),
      ),
    );
  }

  Widget _centeredIcon(bool enabled, BuildContext context) {
    return Center(
      child: Icon(
        enabled ? Icons.check_circle : Icons.remove,
        color:
            enabled
                ? Theme.of(context).canvasColor
                : Theme.of(context).dividerColor,
        size: 20,
      ),
    );
  }

  Widget _cellText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(text, style: TextStyle(fontSize: 14, color: Colors.black87)),
    );
  }
}
