import SwiftUI

struct ContentView: View {
    @State private var difficulty: Difficulty = .hard
    @State private var selected: Component?
    @State private var scenario = scenarios[0]
    @State private var score = 0
    @State private var checks = 0
    @State private var showDiagnostics = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex:"#070C12").ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 12) {
                        header
                        faultCard
                        plantView
                        statusBar
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 24)
                }
            }
            .sheet(item: $selected) { component in
                ComponentSheet(component: component,
                               difficulty: difficulty,
                               scenario: scenario,
                               score: $score,
                               checks: $checks)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    var header: some View {
        HStack {
            VStack(alignment:.leading, spacing:2) {
                Text("DIAGNOSE SHK")
                    .font(.system(size:15, weight:.black))
                    .tracking(2)
                Text("Interaktive Heizungsdiagnose")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Picker("", selection:$difficulty) {
                ForEach(Difficulty.allCases, id:\.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.menu)
            .tint(Color.cyan)
            .padding(7)
            .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius:12))
        }
    }

    var faultCard: some View {
        HStack(alignment:.top, spacing:10) {
            VStack(alignment:.leading, spacing:6) {
                Text("AKTIVE STÖRUNG")
                    .font(.system(size:10, weight:.black))
                    .tracking(1.4)
                    .foregroundStyle(.cyan)
                Text(scenario.title)
                    .font(.headline.bold())
                Text(scenario.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("08:42")
                .font(.system(.headline, design:.monospaced).bold())
                .foregroundStyle(.black)
                .padding(.horizontal,10)
                .padding(.vertical,9)
                .background(.yellow, in: Capsule())
        }
        .padding(14)
        .background(Color(hex:"#0D151E"), in: RoundedRectangle(cornerRadius:16))
        .overlay(RoundedRectangle(cornerRadius:16).stroke(.cyan.opacity(0.7)))
    }

    var plantView: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius:18)
                    .fill(LinearGradient(colors:[Color(hex:"#C4CDD1"),Color(hex:"#919DA4")],
                                         startPoint:.top, endPoint:.bottom))
                Pipes()
                BoilerBody()
                BurnerBody()
                PumpBody()
                GaugeBody()
                MAGBody()
                RadiatorBody(x:0.84, y:0.40, label:"HEIZKÖRPER 1")
                RadiatorBody(x:0.84, y:0.51, label:"HEIZKÖRPER 2")
                AnalyzerBody()
                ThermostatBody()

                ForEach(components) { c in
                    Button {
                        selected = c
                    } label: {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 54, height: 54)
                            .overlay(Circle().stroke(.cyan.opacity(0.18), lineWidth:1))
                    }
                    .position(x:geo.size.width*c.x, y:geo.size.height*c.y)
                }

                VStack {
                    Spacer()
                    HStack {
                        Image(systemName:"hand.tap.fill")
                        Text("Bauteil antippen → prüfen, messen und diagnostizieren")
                    }
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
                    .padding(9)
                    .background(.black.opacity(0.78), in: Capsule())
                    .padding(10)
                }
            }
        }
        .frame(height:650)
        .clipShape(RoundedRectangle(cornerRadius:18))
        .overlay(RoundedRectangle(cornerRadius:18).stroke(.white.opacity(0.15)))
    }

    var statusBar: some View {
        HStack(spacing:8) {
            Stat(title:"Punkte", value:"\(score)/100")
            Stat(title:"Prüfungen", value:"\(checks)")
            Stat(title:"Status", value:"Störung aktiv")
        }
    }
}

struct Stat: View {
    let title:String; let value:String
    var body: some View {
        VStack(alignment:.leading, spacing:3) {
            Text(title.uppercased()).font(.system(size:9, weight:.black)).foregroundStyle(.secondary)
            Text(value).font(.headline.bold())
        }
        .frame(maxWidth:.infinity, alignment:.leading)
        .padding(11)
        .background(Color(hex:"#0D151E"), in: RoundedRectangle(cornerRadius:13))
    }
}

extension Color {
    init(hex:String) {
        let s = hex.replacingOccurrences(of:"#", with:"")
        let v = UInt64(s, radix:16) ?? 0
        self.init(.sRGB,
                  red:Double((v>>16)&255)/255,
                  green:Double((v>>8)&255)/255,
                  blue:Double(v&255)/255,
                  opacity:1)
    }
}
