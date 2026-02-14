// Phone Detective - All Cases Export
// This file exports all case data

import '../../models/models.dart';
import 'case_01_missing_hiker.dart';
import 'case_02_office_theft.dart';
import 'case_03_reunion_murder.dart';
import 'case_04_locked_room.dart';
import 'case_05_jealous_partner.dart';
import 'case_06_blackmail.dart';
import 'case_07_accident_or_not.dart';
import 'case_08_vanishing_witness.dart';
import 'case_09_serial_pattern.dart';
import 'case_10_detectives_phone.dart';

export '../../models/models.dart';

final List<CaseData> allCases = [
  case01MissingHiker,
  case02OfficeTheft,
  case03ReunionMurder,
  case04LockedRoom,
  case05JealousPartner,
  case06Blackmail,
  case07AccidentOrNot,
  case08VanishingWitness,
  case09SerialPattern,
  case10DetectivesPhone,
];

CaseData getCaseByNumber(int number) {
  if (number < 1 || number > allCases.length) {
    throw ArgumentError('Invalid case number: $number');
  }
  return allCases[number - 1];
}
