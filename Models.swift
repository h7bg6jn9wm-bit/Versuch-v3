import Foundation

enum Difficulty: String, CaseIterable {
    case beginner = "Anfänger"
    case hard = "Schwer"
}

enum ComponentKind: String, CaseIterable {
    case boiler, burner, pump, gauge, mag, safetyValve, filter, gasValve, analyzer, thermostat, radiator
}

struct Component: Identifiable {
    let id = UUID()
    let name: String
    let kind: ComponentKind
    let subtitle: String
    let x: CGFloat
    let y: CGFloat
}

struct Reading: Identifiable {
    let id = UUID()
    let name: String
    let value: String
    let unit: String
}

struct FaultScenario {
    let title: String
    let description: String
    let solution: ComponentKind
}

let components: [Component] = [
    .init(name:"Heizkessel", kind:.boiler, subtitle:"Kessel / Wärmeerzeuger", x:0.50, y:0.48),
    .init(name:"Ölbrenner", kind:.burner, subtitle:"Brennerautomat", x:0.50, y:0.79),
    .init(name:"Manometer", kind:.gauge, subtitle:"Anlagendruck", x:0.66, y:0.30),
    .init(name:"Heizungspumpe", kind:.pump, subtitle:"Umwälzpumpe", x:0.62, y:0.56),
    .init(name:"MAG", kind:.mag, subtitle:"Membran-Ausdehnungsgefäß", x:0.69, y:0.68),
    .init(name:"Sicherheitsventil", kind:.safetyValve, subtitle:"3 bar", x:0.81, y:0.71),
    .init(name:"Schmutzfänger", kind:.filter, subtitle:"Heizkreis", x:0.83, y:0.62),
    .init(name:"Gasarmatur", kind:.gasValve, subtitle:"Gasstrecke", x:0.43, y:0.88),
    .init(name:"Abgasanalyse", kind:.analyzer, subtitle:"O₂ / CO₂ / CO", x:0.17, y:0.30),
    .init(name:"Raumregler", kind:.thermostat, subtitle:"Sollwert 22 °C", x:0.63, y:0.90),
    .init(name:"Heizkörper 1", kind:.radiator, subtitle:"Heizkreis", x:0.84, y:0.40),
    .init(name:"Heizkörper 2", kind:.radiator, subtitle:"Heizkreis", x:0.84, y:0.50)
]

let scenarios = [
    FaultScenario(title:"Brenner startet nicht",
                  description:"Wärmeanforderung liegt an. Der Brenner führt einen Startversuch aus, bildet aber keine stabile Flamme.",
                  solution:.burner),
    FaultScenario(title:"Heizkreis ohne ausreichenden Volumenstrom",
                  description:"Die Pumpe läuft, trotzdem bleiben Teile des Heizkreises kalt. Prüfe den hydraulischen Weg.",
                  solution:.filter),
    FaultScenario(title:"Anlagendruck instabil",
                  description:"Der Druck verändert sich zwischen kaltem und warmem Zustand ungewöhnlich stark.",
                  solution:.mag)
]
