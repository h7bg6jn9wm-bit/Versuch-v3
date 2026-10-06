import SwiftUI

struct Pipes: View {
    var body: some View {
        Canvas { ctx, size in
            var p = Path()
            p.move(to:CGPoint(x:size.width*0.50,y:size.height*0.58))
            p.addLine(to:CGPoint(x:size.width*0.50,y:size.height*0.82))
            p.addLine(to:CGPoint(x:size.width*0.84,y:size.height*0.82))
            p.addLine(to:CGPoint(x:size.width*0.84,y:size.height*0.38))
            ctx.stroke(p, with:.color(.blue), lineWidth:8)
            var p2 = Path()
            p2.move(to:CGPoint(x:size.width*0.50,y:size.height*0.66))
            p2.addLine(to:CGPoint(x:size.width*0.64,y:size.height*0.66))
            p2.addLine(to:CGPoint(x:size.width*0.84,y:size.height*0.66))
            ctx.stroke(p2, with:.color(.blue), lineWidth:8)
            var gas = Path()
            gas.move(to:CGPoint(x:size.width*0.43,y:size.height*0.89))
            gas.addLine(to:CGPoint(x:size.width*0.50,y:size.height*0.89))
            gas.addLine(to:CGPoint(x:size.width*0.50,y:size.height*0.78))
            ctx.stroke(gas, with:.color(.yellow), lineWidth:7)
        }
    }
}

struct BoilerBody: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:16).fill(.gray.opacity(0.22)).frame(width:220,height:360)
            RoundedRectangle(cornerRadius:12).fill(Color(hex:"#E3E1D2")).frame(width:205,height:345)
            RoundedRectangle(cornerRadius:8).fill(Color(hex:"#4F5960")).frame(width:175,height:115).offset(y:-70)
            ForEach(0..<4,id:\.self) { i in Rectangle().fill(.blue).frame(width:150,height:7).offset(y:CGFloat(-100+i*25)) }
            RoundedRectangle(cornerRadius:5).fill(Color.black.opacity(0.85)).frame(width:72,height:34).overlay(Text("62.4°C").font(.caption2.bold()).foregroundStyle(.cyan)).offset(x:-60,y:-160)
            Circle().fill(.white).frame(width:54,height:54).overlay(Text("1.2").font(.caption.bold())).offset(x:70,y:-160)
            Text("HEIZKESSEL").font(.caption.bold()).offset(y:165)
        }
    }
}

struct BurnerBody: View {
    var body: some View {
        HStack(spacing:10) {
            Circle().fill(.red).frame(width:46,height:46).overlay(Circle().fill(.yellow).frame(width:18,height:18))
            RoundedRectangle(cornerRadius:5).fill(Color.black).frame(width:85,height:38).overlay(Text("LOCKOUT").font(.caption2.bold()).foregroundStyle(.cyan))
        }
        .padding(10)
        .background(Color(hex:"#202A31"), in:RoundedRectangle(cornerRadius:10))
        .overlay(Text("ÖLBRENNER").font(.caption.bold()).offset(y:48))
        .position(x:180,y:550)
    }
}

struct PumpBody: View {
    var body: some View {
        ZStack {
            Circle().fill(Color(hex:"#222D34")).frame(width:60,height:60)
            Circle().fill(.gray).frame(width:38,height:38)
            Image(systemName:"arrowtriangle.right.fill").foregroundStyle(.black)
            Text("PUMPE").font(.caption2.bold()).offset(y:42)
        }
        .position(x:0,y:0)
    }
}

struct GaugeBody: View {
    var body: some View {
        ZStack {
            Circle().fill(.white).frame(width:58,height:58)
            Text("1.2").font(.caption.bold())
            Text("bar").font(.system(size:8)).offset(y:12)
            Text("MANOMETER").font(.caption2.bold()).offset(y:43)
        }
        .position(x:0,y:0)
    }
}

struct MAGBody: View {
    var body: some View {
        Capsule().fill(.red).frame(width:48,height:105).overlay(Text("MAG").font(.caption2.bold()).offset(y:64))
    }
}

struct RadiatorBody: View {
    let x:CGFloat; let y:CGFloat; let label:String
    var body: some View {
        VStack(spacing:3) {
            Text(label).font(.system(size:8,weight:.black))
            HStack(spacing:3) { ForEach(0..<8,id:\.self){ _ in Rectangle().fill(.gray).frame(width:6,height:45) } }
                .padding(7).background(.gray.opacity(0.25),in:RoundedRectangle(cornerRadius:6))
        }
        .position(x:0,y:0)
    }
}

struct AnalyzerBody: View {
    var body: some View {
        VStack(alignment:.leading,spacing:3) {
            Text("ABGASANALYSE").font(.caption2.bold())
            Text("O₂ 20.9 %").foregroundStyle(.cyan)
            Text("CO₂ 0.0 %").foregroundStyle(.cyan)
            Text("CO 8 ppm").foregroundStyle(.cyan)
        }
        .font(.caption2.monospacedDigit())
        .padding(10).background(.black.opacity(0.88),in:RoundedRectangle(cornerRadius:10))
        .position(x:95,y:180)
    }
}

struct ThermostatBody: View {
    var body: some View {
        VStack(spacing:4) {
            RoundedRectangle(cornerRadius:8).fill(.black).frame(width:105,height:38).overlay(Text("22.0 °C").foregroundStyle(.cyan).font(.caption.bold()))
            Text("RAUMREGLER").font(.caption2.bold())
        }
        .position(x:0,y:0)
    }
}
