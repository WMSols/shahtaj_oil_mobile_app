import 'package:flutter_test/flutter_test.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_summary_model.dart';

void main() {
  group('ObVisitSummaryModel', () {
    test('parseOutcome maps snake_case values', () {
      expect(
        ObVisitSummaryModel.parseOutcome('order_placed'),
        VisitOutcome.orderPlaced,
      );
      expect(
        ObVisitSummaryModel.parseOutcome('ended_without_order'),
        VisitOutcome.endedWithoutOrder,
      );
      expect(ObVisitSummaryModel.parseOutcome('skipped'), VisitOutcome.skipped);
    });

    test('fromJson maps list item fields', () {
      final model = ObVisitSummaryModel.fromJson({
        'visit_id': 42,
        'shop_name': 'Test Shop',
        'owner_name': 'Owner',
        'checked_in_at': '2026-07-01T10:30:00',
        'checked_out_at': '2026-07-01T11:00:00',
        'outcome': 'order_placed',
        'order_id': 99,
        'order_number': 'SO-99',
        'subtotal': 1500,
      });

      expect(model.visitId, 42);
      expect(model.shopName, 'Test Shop');
      expect(model.outcome, VisitOutcome.orderPlaced);
      expect(model.orderId, 99);
      expect(model.subtotal, 1500);
    });
  });

  group('AppMockData visit history', () {
    test('contains multiple visits with varied outcomes', () {
      final visits = AppMockData.obVisitHistory;
      expect(visits.length, greaterThanOrEqualTo(5));
      expect(
        visits.any((visit) => visit.outcome == VisitOutcome.orderPlaced),
        isTrue,
      );
      expect(
        visits.any((visit) => visit.outcome == VisitOutcome.endedWithoutOrder),
        isTrue,
      );
    });

    test('obVisitDetail returns lines for order visits', () {
      final detail = AppMockData.obVisitDetail(8801);
      expect(detail.visitId, 8801);
      expect(detail.lines, isNotEmpty);
      expect(detail.hasOrder, isTrue);
    });

    test('obVisitDetail includes notes for no-order visits', () {
      final detail = AppMockData.obVisitDetail(8795);
      expect(detail.outcome, VisitOutcome.endedWithoutOrder);
      expect(detail.notes, isNotNull);
      expect(detail.lines, isEmpty);
    });
  });

  group('ObVisitListResult', () {
    test('fromJson parses visits and total', () {
      final result = ObVisitListResult.fromJson({
        'total': 2,
        'visits': [
          {
            'visit_id': 1,
            'shop_name': 'A',
            'checked_in_at': '2026-07-01T09:00:00',
            'outcome': 'order_placed',
          },
          {
            'visit_id': 2,
            'shop_name': 'B',
            'checked_in_at': '2026-07-02T09:00:00',
            'outcome': 'skipped',
          },
        ],
      });

      expect(result.total, 2);
      expect(result.visits.length, 2);
      expect(result.visits.first.outcome, VisitOutcome.orderPlaced);
    });
  });
}
