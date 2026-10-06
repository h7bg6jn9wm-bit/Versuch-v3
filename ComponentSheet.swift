import SwiftUI

struct ComponentSheet: View {
    let component: Component
    let difficulty: Difficulty
    let scenario: FaultScenario
    @Binding var score: Int
    @Binding var checks: Int

    @Environment(\.dismiss) private var dismiss
    @State private var message = ""
    @State private var selectedAction = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading, spacing:14) {
                    HStack {
                        VStack(alignment:.leading) {
                            Text("BAUTEILPRÜFUNG").font(.system(size:10,weight:.black)).tracking(1.4).foregroundStyle(.cyan)
                            Text(component.name).font(.title2.bold())
                            Text(component.subtitle).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: icon)
                            .font(.title)
                            .foregroundStyle(.cyan)
                            .padding(13)
                            .background(.cyan.opacity(0.1),in:RoundedRectangle(cornerRadius:14))
                    }

                    readings

                    Text("DIAGNOSEWERKZEUGE").font(.system(size:10,weight:.black)).tracking(1.4).foregroundStyle(.secondary)

                    ForEach(actions, id:\.self) { action in
                        Button {
                            perform(action)
                        } label: {
                            HStack {
                                Image(systemName: actionIcon(action))
                                Text(action)
                                Spacer()
                                Image(systemName:"chevron.right").font(.caption)
                            }
                            .padding(14)
                            .background(Color(hex:"#111E28"),in:RoundedRectangle(cornerRadius:13))
                            .overlay(RoundedRectangle(cornerRadius:13).stroke(.white.opacity(0.08)))
                        }
                    }

                    if !message.isEmpty {
                        Text(message)
                            .font(.subheadline)
                            .padding(14)
                            .frame(maxWidth:.infinity,alignment:.leading)
                            .background(message.contains("Treffer") ? Color.green.opacity(0.12) : Color.orange.opacity(0.10),
                                        in:RoundedRectangle(cornerRadius:13))
                    }
                }
                .padding()
            }
            .background(Color(hex:"#0A1118"))
            .navigationTitle("Prüfung")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var readings: some View {
        LazyVGrid(columns:[GridItem(.flexible()),GridItem(.flexible())],spacing:8) {
            ForEach(readingData, id:\.0) { item in
                VStack(alignment:.leading,spacing:4) {
                    Text(item.0).font(.caption).foregroundStyle(.secondary)
                    Text(item.1).font(.headline.monospacedDigit())
                }
                .frame(maxWidth:.infinity,alignment:.leading)
                .padding(11)
                .background(Color(hex:"#111E28"),in:RoundedRectangle(cornerRadius:12))
            }
        }
    }

    var readingData: [(String,String)] {
        switch component.kind {
        case .boiler: return [("Vorlauf","62.4 °C"),("Rücklauf","48.1 °C"),("Druck","1.2 bar"),("Anforderung","EIN")]
        case .burner: return [("Status","Störung"),("Flamme","keine"),("Motor","läuft"),("Zündung","aktiv")]
        case .pump: return [("Drehzahl","2.850 1/min"),("Volumenstrom","1.6 m³/h"),("Δp","180 mbar"),("Signal","100 %")]
        case .gauge: return [("Anzeige","1.2 bar"),("Soll","1.0–2.0 bar"),("Dynamik","stabil"),("Abweichung","keine")]
        case .mag: return [("Anlagendruck","1.2 bar"),("Vordruck","0.8 bar"),("Volumen","50 l"),("Membran","prüfen")]
        case .safetyValve: return [("Nennwert","3.0 bar"),("Abblaseweg","frei"),("Tropfen","nein"),("Status","bereit")]
        case .filter: return [("Δp","0.08 bar"),("Verschmutzung","mittel"),("Durchfluss","vorhanden"),("Status","eingeschränkt")]
        case .gasValve: return [("Ventil","öffnet"),("Eingang","22 mbar"),("Ausgang","18 mbar"),("Freigabe","EIN")]
        case .analyzer: return [("O₂","20.9 %"),("CO₂","0.0 %"),("CO","8 ppm"),("Abgas","22 °C")]
        case .thermostat: return [("Raum","21.0 °C"),("Soll","22.0 °C"),("Anforderung","EIN"),("Signal","0–10 V")]
        case .radiator: return [("Vorlauf","61.8 °C"),("Rücklauf","48.7 °C"),("Ventil","offen"),("Leistung","normal")]
        }
    }

    var actions: [String] {
        switch component.kind {
        case .burner: return ["Störcode auslesen","Ölversorgung prüfen","Zündanlage prüfen","Flammenüberwachung prüfen"]
        case .pump: return ["Pumpenstatus prüfen","Absperrungen prüfen","Drehzahl verändern","Volumenstrom messen"]
        case .mag: return ["Vordruck messen","Membran prüfen","Druckverlauf beobachten","Füllarmatur prüfen"]
        case .filter: return ["Differenzdruck messen","Sieb prüfen","Sieb reinigen","Absperrungen prüfen"]
        case .gauge: return ["Mit externem Manometer vergleichen","Druckverlauf beobachten","Anschluss prüfen","Anzeige auf Blockade prüfen"]
        default: return ["Messwert aufnehmen","Elektrische Freigabe prüfen","Funktion testen","Verbindung prüfen"]
        }
    }

    var icon: String {
        switch component.kind {
        case .burner: return "flame.fill"
        case .pump: return "arrow.triangle.2.circlepath"
        case .gauge: return "gauge.with.dots.needle.bottom.50percent"
        case .mag: return "cylinder.fill"
        case .filter: return "line.3.horizontal.decrease.circle"
        default: return "wrench.and.screwdriver.fill"
        }
    }

    func actionIcon(_ a:String)->String {
        if a.contains("messen") || a.contains("Messwert") { return "waveform.path.ecg" }
        if a.contains("Störcode") { return "exclamationmark.triangle" }
        if a.contains("prüfen") { return "checkmark.seal" }
        return "wrench.and.screwdriver"
    }

    func perform(_ action:String) {
        checks += 1
        selectedAction = action

        let directHit =
            (scenario.solution == component.kind) ||
            (scenario.solution == .filter && component.kind == .pump)

        if directHit {
            score = min(100, score + (difficulty == .hard ? 8 : 5))
            message = "Treffer: Diese Prüfung liefert einen relevanten Diagnosehinweis. Jetzt Messwert bewerten und die Fehlerkette weiter eingrenzen."
        } else {
            message = "Messung durchgeführt. Der Wert ist plausibel. Die Prüfung grenzt die Ursache ein, ist aber noch kein eindeutiger Fehlernachweis."
        }
    }
}
