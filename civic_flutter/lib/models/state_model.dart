class NigerianState {
  final String name;
  final String code;

  NigerianState({required this.name, required this.code});
}

List<NigerianState> allStates = [
  NigerianState(name: "Abia", code: "AB"),
  // NigerianState(name: "Adamawa", code: "AD"),
  NigerianState(name: "Akwa Ibom", code: "AK"),
  NigerianState(name: "Anambra", code: "AN"),
  // NigerianState(name: "Bauchi", code: "BA"),
  // NigerianState(name: "Bayelsa", code: "BY"),
  // NigerianState(name: "Benue", code: "BE"),
  // NigerianState(name: "Borno", code: "BO"),
  // NigerianState(name: "Cross River", code: "CR"),
  // NigerianState(name: "Delta", code: "DE"),
  // NigerianState(name: "Ebonyi", code: "EB"),
  NigerianState(name: "Edo", code: "ED"),
  // NigerianState(name: "Ekiti", code: "EK"),
  // NigerianState(name: "Enugu", code: "EN"),
  // NigerianState(name: "Gombe", code: "GO"),
  NigerianState(name: "Imo", code: "IM"),
  // NigerianState(name: "Jigawa", code: "JI"),
  // NigerianState(name: "Kaduna", code: "KD"),
  // NigerianState(name: "Kano", code: "KN"),
  // NigerianState(name: "Katsina", code: "KT"),
  // NigerianState(name: "Kebbi", code: "KE"),
  NigerianState(name: "Kogi", code: "KO"),
  // NigerianState(name: "Kwara", code: "KW"),
  NigerianState(name: "Lagos", code: "LA"),
  // NigerianState(name: "Nasarawa", code: "NA"),
  // NigerianState(name: "Niger", code: "NI"),
  // NigerianState(name: "Ogun", code: "OG"),
  // NigerianState(name: "Ondo", code: "ON"),
  // NigerianState(name: "Osun", code: "OS"),
  // NigerianState(name: "Oyo", code: "OY"),
  // NigerianState(name: "Plateau", code: "PL"),
  // NigerianState(name: "Rivers", code: "RI"),
  // NigerianState(name: "Sokoto", code: "SO"),
  // NigerianState(name: "Taraba", code: "TA"),
  // NigerianState(name: "Yobe", code: "YO"),
  // NigerianState(name: "Zamfara", code: "ZA"),
  NigerianState(name: "FCT", code: "FC"),
];
NigerianState? getStateByCode(String code) {
  try {
    return allStates.firstWhere(
      (state) => state.code.toUpperCase() == code.toUpperCase(),
    );
  } catch (e) {
    return null;
  }
}