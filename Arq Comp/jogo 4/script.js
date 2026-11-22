// Fia e os Fios da Arquitetura
// HTML, CSS e JavaScript puros. A cena 3D é desenhada à mão no <canvas>:
// cada ponto tem x, y, z, e a função "proj" transforma esse ponto 3D em um ponto 2D da tela
// (rotação da câmera + perspectiva). Não usa nenhuma biblioteca.

(function () {
  "use strict";

  // =====================================================================
  // 1. CONTEÚDO DO JOGO (as 16 palavras da atividade)
  // =====================================================================
  var palavras = [
    { nome: "CPU", resposta: "CPU", grupo: "cpu",
      pista: "O cérebro do computador, executa as instruções dos programas.",
      explicacao: "CPU significa Unidade Central de Processamento. Ela é formada pela ULA, pela UC e pelos registradores." },
    { nome: "ULA", resposta: "ULA", grupo: "cpu",
      pista: "Parte da CPU que faz as contas e as operações lógicas.",
      explicacao: "ULA é a Unidade Lógica e Aritmética. Ela faz somas, subtrações, comparações e operações lógicas." },
    { nome: "UC (Unidade de Controle)", resposta: "UC", grupo: "cpu",
      pista: "Parte da CPU que comanda o que cada componente deve fazer.",
      explicacao: "A Unidade de Controle busca e interpreta as instruções e coordena os outros componentes." },
    { nome: "Registradores", resposta: "REGISTRADORES", grupo: "cpu",
      pista: "Minúsculas memórias dentro do processador, rapidíssimas, guardam dados do momento.",
      explicacao: "São as memórias mais rápidas do computador e ficam dentro da CPU. Guardam dados e resultados do momento." },
    { nome: "RAM", resposta: "RAM", grupo: "mem",
      pista: "Memória principal e volátil onde ficam os programas em uso.",
      explicacao: "RAM é a memória de acesso aleatório. Ela é volátil: quando o computador desliga, tudo é perdido." },
    { nome: "ROM", resposta: "ROM", grupo: "mem",
      pista: "Memória que só é lida e não perde os dados sem energia.",
      explicacao: "ROM é a memória somente de leitura. Ela é não volátil e guarda programas fixos, como os de inicialização." },
    { nome: "EEPROM", resposta: "EEPROM", grupo: "mem",
      pista: "Memória não volátil que pode ser apagada com eletricidade, byte a byte.",
      explicacao: "EEPROM é uma ROM programável e apagável eletricamente. Dá para regravar sem tirar o chip da placa." },
    { nome: "Flash", resposta: "FLASH", grupo: "mem",
      pista: "Memória não volátil usada em pen drives e cartões SD.",
      explicacao: "A memória Flash é parecida com a EEPROM, mas é apagada em blocos. Por isso é rápida e barata." },
    { nome: "Cache", resposta: "CACHE", grupo: "mem",
      pista: "Memória pequena e veloz perto da CPU, guarda o que é muito usado.",
      explicacao: "A cache fica entre a CPU e a RAM. Ela deixa o acesso aos dados mais usados bem mais rápido." },
    { nome: "Memória de massa (armazenamento)", resposta: "MEMORIADEMASSA", grupo: "mem",
      pista: "Onde seus arquivos ficam de forma permanente, como no HD ou SSD.",
      explicacao: "É a memória de grande capacidade e não volátil, como HD e SSD. É mais lenta que a RAM." },
    { nome: "DMA", resposta: "DMA", grupo: "tra",
      pista: "Deixa dispositivos trocarem dados com a RAM sem incomodar a CPU.",
      explicacao: "DMA é o Acesso Direto à Memória. A CPU fica livre para fazer outras tarefas enquanto os dados são transferidos." },
    { nome: "Address bus (barramento de endereço)", resposta: "ADDRESSBUS", grupo: "tra",
      pista: "Caminho que indica qual posição da memória será lida ou escrita.",
      explicacao: "O barramento de endereço leva o endereço da CPU até a memória. Ele só vai em um sentido." },
    { nome: "Data bus (barramento de dados)", resposta: "DATABUS", grupo: "tra",
      pista: "Caminho de ida e volta por onde o conteúdo viaja entre os componentes.",
      explicacao: "O barramento de dados transporta os dados e funciona nos dois sentidos: lê e escreve." },
    { nome: "Microcontrolador", resposta: "MICROCONTROLADOR", grupo: "sis",
      pista: "Chip pequeno que junta processador, memória e portas, usado em aparelhos embarcados.",
      explicacao: "É um computador inteiro em um só chip. Aparece em eletrodomésticos, carros e placas como o Arduino." },
    { nome: "Dual core", resposta: "DUALCORE", grupo: "sis",
      pista: "Processador com dois núcleos trabalhando juntos.",
      explicacao: "Dual core quer dizer dois núcleos. Eles podem executar duas tarefas ao mesmo tempo." },
    { nome: "Quad core", resposta: "QUADCORE", grupo: "sis",
      pista: "Processador com quatro núcleos trabalhando juntos.",
      explicacao: "Quad core quer dizer quatro núcleos. Dá para executar até quatro tarefas ao mesmo tempo." }
  ];

  var GRUPOS = { cpu: "Processador", mem: "Memórias", tra: "Transferência", sis: "Sistemas" };
  var TOTAL = palavras.length; // 16

  // =====================================================================
  // 2. UTILIDADES
  // =====================================================================
  var TAU = Math.PI * 2;
  function $(id) { return document.getElementById(id); }
  function limitar(v, a, b) { return Math.max(a, Math.min(b, v)); }
  function sortear(a) { return a[Math.floor(Math.random() * a.length)]; }

  function embaralhar(lista) {
    for (var i = lista.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var t = lista[i]; lista[i] = lista[j]; lista[j] = t;
    }
    return lista;
  }

  // localStorage pode estar bloqueado: por isso o try/catch
  function guardar(chave, valor) { try { localStorage.setItem(chave, JSON.stringify(valor)); } catch (e) {} }
  function ler(chave, padrao) {
    try { var v = localStorage.getItem(chave); return v ? JSON.parse(v) : padrao; } catch (e) { return padrao; }
  }

  // =====================================================================
  // 3. SOM (sintetizado no navegador, sem arquivos)
  // =====================================================================
  var audioCtx = null;
  var somLigado = true;

  function tom(freq, dur, tipo, vol, atraso) {
    if (!somLigado) return;
    try {
      if (!audioCtx) audioCtx = new (window.AudioContext || window.webkitAudioContext)();
      var o = audioCtx.createOscillator();
      var g = audioCtx.createGain();
      var t0 = audioCtx.currentTime + (atraso || 0);
      o.type = tipo || "sine";
      o.frequency.setValueAtTime(freq, t0);
      g.gain.setValueAtTime(0.0001, t0);
      g.gain.exponentialRampToValueAtTime(vol || 0.07, t0 + 0.015);
      g.gain.exponentialRampToValueAtTime(0.0001, t0 + dur);
      o.connect(g); g.connect(audioCtx.destination);
      o.start(t0); o.stop(t0 + dur + 0.03);
    } catch (e) {}
  }
  function somClique() { tom(520, 0.07, "triangle", 0.05); }
  function somAcerto() { tom(523, 0.14, "triangle", 0.08, 0); tom(659, 0.14, "triangle", 0.08, 0.09); tom(784, 0.28, "triangle", 0.09, 0.18); }
  function somErro() { tom(220, 0.2, "sawtooth", 0.05, 0); tom(165, 0.3, "sawtooth", 0.05, 0.14); }
  function somPulo() { tom(300 + Math.random() * 120, 0.06, "sine", 0.035); }
  function somFim() { [523, 659, 784, 1047].forEach(function (f, i) { tom(f, 0.3, "triangle", 0.08, i * 0.13); }); }

  // =====================================================================
  // 4. ESTADO DO JOGO
  // =====================================================================
  var G = {
    estado: "menu",     // menu | quiz | fim
    ordem: [],          // índices das palavras, embaralhados
    pos: 0,             // pergunta atual
    nos: [],            // estado de cada fio da teia: 0 pendente, 1 certo, 2 errado
    acertos: 0,
    pontos: 0,
    combo: 0,
    melhorCombo: 0,
    erros: [],          // índices das palavras erradas
    opcoes: [],         // 4 índices de palavras (opções da pergunta)
    respondido: false,
    dicas: 3,
    dicaUsada: false,
    t0: 0
  };

  // =====================================================================
  // 5. CENA 3D
  // =====================================================================
  var N = 16;                                   // fios (um por palavra)
  var RAIO = 1.6;                               // raio da teia
  var ANEIS = [0.18, 0.34, 0.5, 0.66, 0.82, 1]; // anéis da teia (fração do raio)

  var cv = $("cena");
  var cx = cv.getContext("2d");
  var W = 0, H = 0, dpr = 1, F = 600;

  // câmera: yaw gira em volta, pitch inclina, D é a distância
  var cam = { yaw: 0, pitch: 0.45, D: 3.3, cy: 0.56 };
  var camAlvo = { pitch: 0.45, D: 3.3, cy: 0.56 };
  var arrasto = { yaw: 0, pitch: 0, ativo: false, x: 0, y: 0 };
  var pitchEf = 0.45;

  function ajustar() {
    var r = cv.parentNode.getBoundingClientRect();
    if (r.width < 10) return;
    dpr = Math.min(2, window.devicePixelRatio || 1);
    W = r.width; H = r.height;
    cv.width = Math.round(W * dpr);
    cv.height = Math.round(H * dpr);
  }

  // Transforma um ponto 3D do mundo em ponto 2D da tela.
  // (x,y,z) = posição no mundo. (ox,oy,oz) = deslocamento extra já no "espaço da câmera"
  // (usado para desenhar as partes da Fia sempre viradas para o jogador).
  function proj(x, y, z, ox, oy, oz) {
    var cyw = Math.cos(cam.yaw), syw = Math.sin(cam.yaw);
    var x1 = x * cyw + z * syw + (ox || 0);
    var z1 = -x * syw + z * cyw + (oz || 0);
    var y1 = y + (oy || 0);
    var cp = Math.cos(pitchEf), sp = Math.sin(pitchEf);
    var y2 = y1 * cp + z1 * sp;
    var z2 = -y1 * sp + z1 * cp;
    var s = F / (z2 + cam.D);
    return { x: W / 2 + x1 * s, y: H * cam.cy - y2 * s, s: s, z: z2 };
  }

  function angulo(k) { return -Math.PI / 2 + (k * TAU) / N; }
  function alturaTeia(r) { var q = r / RAIO; return 0.24 * (1 - q * q); } // a teia é uma "barraca"

  function pontoTeia(a, r, t) {
    var y = alturaTeia(r) + (r > 0 ? Math.sin(t * 1.4 + a * 3 + r * 5) * 0.012 : 0);
    return [Math.cos(a) * r, y, Math.sin(a) * r];
  }
  function P(arr) { return proj(arr[0], arr[1], arr[2]); }

  // pequenos desenhos auxiliares
  function retArred(x, y, w, h, r) {
    cx.beginPath();
    cx.moveTo(x + r, y);
    cx.arcTo(x + w, y, x + w, y + h, r);
    cx.arcTo(x + w, y + h, x, y + h, r);
    cx.arcTo(x, y + h, x, y, r);
    cx.arcTo(x, y, x + w, y, r);
    cx.closePath();
  }
  function elipse(x, y, rx, ry) { cx.beginPath(); cx.ellipse(x, y, Math.max(0.01, rx), Math.max(0.01, ry), 0, 0, TAU); }
  function circulo(x, y, r) { cx.beginPath(); cx.arc(x, y, Math.max(0.01, r), 0, TAU); }

  function esfera(x, y, r, c0, c1, c2) {
    var g = cx.createRadialGradient(x - r * 0.35, y - r * 0.4, r * 0.08, x, y, r);
    g.addColorStop(0, c0); g.addColorStop(0.55, c1); g.addColorStop(1, c2);
    cx.fillStyle = g; circulo(x, y, r); cx.fill();
    cx.strokeStyle = "rgba(255,255,255,0.16)"; cx.lineWidth = 1; cx.stroke();
  }

  // ---------- Fia (personagem) ----------
  var fia = {
    x: 0, z: 0, de: [0, 0], para: [0, 0],
    andando: false, prog: 0, dur: 1, aoChegar: null, w: 0,
    humor: "idle", humorAte: 0,
    olhaX: 0, olhaY: 0, giro: 0,
    pisca: 0, proxPisca: 2, tela: { x: 0, y: 0, r: 40 }
  };

  function definirHumor(h, segundos) {
    fia.humor = h;
    fia.humorAte = segundos ? performance.now() / 1000 + segundos : 0;
  }

  function nosPosicao(k) { // onde a Fia fica quando visita o fio k
    var a = angulo(k);
    return [Math.cos(a) * RAIO * 0.86, Math.sin(a) * RAIO * 0.86];
  }

  function andarPara(x, z, dur, aoChegar) {
    fia.de = [fia.x, fia.z];
    fia.para = [x, z];
    fia.prog = 0;
    fia.dur = dur;
    fia.andando = true;
    fia.aoChegar = aoChegar || null;
  }

  function desenharFia(t) {
    var wy = alturaTeia(Math.hypot(fia.x, fia.z));
    var pulo = fia.andando ? Math.abs(Math.sin(fia.prog * Math.PI * 3)) * 0.22 : 0;
    var festa = fia.humor === "feliz" ? Math.abs(Math.sin(t * 7)) * 0.13 : 0;
    var balanco = Math.sin(t * 2.2) * 0.025;
    var dy = pulo + festa + balanco;
    var FS = 1.0 - 0.25 * limitar((cam.D - 3.3) / 1.8, 0, 1); // um pouco menor quando a câmera está longe
    var cph = Math.cos(fia.giro), sph = Math.sin(fia.giro);
    // A Fia fica quase "de frente" para a câmera: só inclinamos o corpo dela em parte do ângulo da câmera.
    var inclinacao = pitchEf * 0.2 - pitchEf;
    var ci = Math.cos(inclinacao), si = Math.sin(inclinacao);

    // ponto local da Fia -> tela
    function pt(ox, oy, oz) {
      var rx = ox * cph + oz * sph, rz = -ox * sph + oz * cph;
      var ry2 = oy * ci + rz * si, rz2 = -oy * si + rz * ci;
      return proj(fia.x, wy, fia.z, rx * FS, dy + ry2 * FS, rz2 * FS);
    }

    var base = proj(fia.x, wy, fia.z, 0, 0, 0);
    fia.tela.x = base.x; fia.tela.y = base.y - 0.5 * base.s; fia.tela.r = 0.5 * base.s;

    // sombra
    var alt = Math.max(0, 1 - dy * 2.2);
    cx.fillStyle = "rgba(0,0,0," + (0.3 * alt) + ")";
    elipse(base.x, base.y + 0.02 * base.s, 0.62 * base.s * alt, (0.62 * Math.sin(pitchEf) + 0.08) * base.s * alt * 0.6);
    cx.fill();

    var lista = [];
    function add(z, f) { lista.push({ z: z, f: f }); }

    var humor = fia.humor;
    var andar = fia.w;

    // --- pernas (4 de cada lado) ---
    [-1, 1].forEach(function (sg) {
      for (var i = 0; i < 4; i++) {
        (function (i) {
          var fase = t * 9 + (i % 2) * Math.PI + (sg > 0 ? Math.PI / 2 : 0);
          var hip = [sg * 0.28, 0.22, -0.14 + i * 0.13];
          var fx = sg * (0.88 - (i === 0 || i === 3 ? 0.06 : 0)) + Math.sin(t * 1.7 + i + sg) * 0.015;
          var fz = -0.66 + i * 0.44 + Math.sin(fase) * 0.13 * andar;
          var lev = Math.max(0, Math.cos(fase)) * 0.16 * andar;
          var joelho = [sg * 0.76, 0.7 + lev * 0.8, (hip[2] + fz) / 2];
          var pe = [fx, lev, fz];

          if (humor === "feliz" && i === 0) {            // acena com as patinhas da frente
            pe = [sg * 0.62, 1.0 + Math.sin(t * 10 + sg) * 0.14, -0.55];
            joelho = [sg * 0.72, 0.82, -0.32];
          }
          if (humor === "triste") { joelho[1] = 0.5; pe[0] *= 0.82; }

          var a = pt(hip[0], hip[1], hip[2]);
          var b = pt(joelho[0], joelho[1], joelho[2]);
          var c = pt(pe[0], pe[1], pe[2]);
          add((a.z + b.z + c.z) / 3 + 0.5, function () {
            var lw = 0.075 * FS * ((a.s + c.s) / 2);
            cx.lineCap = "round"; cx.lineJoin = "round";
            cx.strokeStyle = "#35197f"; cx.lineWidth = lw;
            cx.beginPath(); cx.moveTo(a.x, a.y); cx.lineTo(b.x, b.y); cx.lineTo(c.x, c.y); cx.stroke();
            cx.strokeStyle = "#7c5cdb"; cx.lineWidth = lw * 0.42;
            cx.beginPath(); cx.moveTo(a.x, a.y - lw * 0.16); cx.lineTo(b.x, b.y - lw * 0.16); cx.lineTo(c.x, c.y - lw * 0.16); cx.stroke();
            cx.fillStyle = "#ead8ff"; circulo(c.x, c.y, lw * 0.52); cx.fill();
          });
        })(i);
      }
    });

    // --- abdômen ---
    var ab = pt(0, 0.32, 0.44);
    add(ab.z, function () {
      var r = 0.33 * FS * ab.s;
      esfera(ab.x, ab.y, r, "#c9a8ff", "#7c3aed", "#34186f");
      // pintinhas na parte de cima
      cx.fillStyle = "rgba(240,225,255,0.85)";
      [[-0.13, 0.55, 0.38], [0.12, 0.57, 0.5], [0, 0.6, 0.3], [-0.05, 0.5, 0.62]].forEach(function (d) {
        var q = pt(d[0], d[1], d[2]);
        circulo(q.x, q.y, 0.035 * q.s); cx.fill();
      });
    });

    // --- cabeça ---
    var cab = pt(0, 0.46, -0.05);
    add(cab.z, function () {
      var r = 0.44 * FS * cab.s;
      esfera(cab.x, cab.y, r, "#dcc6ff", "#9460f7", "#4a2a9c");
      cx.fillStyle = "rgba(255,255,255,0.22)";
      elipse(cab.x - r * 0.38, cab.y - r * 0.52, r * 0.24, r * 0.12); cx.fill();
    });

    // --- rosto (olhos, bochechas, boca, laço) ---
    var piscando = fia.pisca > 0;
    var abertura = piscando ? 0.08 : 1;
    var olhaX = fia.olhaX, olhaY = fia.olhaY;
    if (humor === "pensa") { olhaX = 0.6; olhaY = -0.7; }
    if (humor === "triste") { olhaY = 0.7; olhaX = 0; }

    function hf(ox, oy) { // ponto do rosto: deslocamento na tela a partir do centro da cabeça
      return { x: cab.x + ox * FS * cab.s, y: cab.y - oy * FS * cab.s, s: cab.s * FS };
    }
    add(cab.z - 0.5, function () {
      [-1, 1].forEach(function (sx) {
        // bochechas
        var ch = hf(sx * 0.3, -0.13);
        cx.fillStyle = humor === "feliz" ? "rgba(255,120,185,0.85)" : "rgba(255,130,190,0.5)";
        elipse(ch.x, ch.y, 0.09 * ch.s, 0.055 * ch.s); cx.fill();

        // olhos
        var e = hf(sx * 0.17, 0.05);
        var er = 0.155 * e.s;
        if (humor === "feliz") {
          cx.strokeStyle = "#241b5e"; cx.lineWidth = er * 0.3; cx.lineCap = "round";
          cx.beginPath(); cx.arc(e.x, e.y + er * 0.3, er * 0.75, Math.PI * 1.1, Math.PI * 1.9); cx.stroke();
        } else {
          cx.fillStyle = "#fff"; elipse(e.x, e.y, er, er * abertura); cx.fill();
          cx.strokeStyle = "rgba(36,27,94,0.55)"; cx.lineWidth = 1.2; cx.stroke();
          if (!piscando) {
            var lx = olhaX * er * 0.34, ly = olhaY * er * 0.3;
            var g = cx.createRadialGradient(e.x + lx, e.y + ly, er * 0.05, e.x + lx, e.y + ly, er * 0.62);
            g.addColorStop(0, "#4338ca"); g.addColorStop(1, "#1b1450");
            cx.fillStyle = g; circulo(e.x + lx, e.y + ly, er * 0.62); cx.fill();
            cx.fillStyle = "#fff"; circulo(e.x + lx - er * 0.2, e.y + ly - er * 0.22, er * 0.2); cx.fill();
            circulo(e.x + lx + er * 0.22, e.y + ly + er * 0.2, er * 0.09); cx.fill();
          }
          if (humor === "triste") {
            cx.strokeStyle = "#241b5e"; cx.lineWidth = er * 0.22; cx.lineCap = "round";
            cx.beginPath();
            cx.moveTo(e.x + sx * er * 1.0, e.y - er * 1.15);
            cx.lineTo(e.x - sx * er * 0.9, e.y - er * 1.7);
            cx.stroke();
            var gota = (t * 1.1) % 1;
            cx.fillStyle = "rgba(125,211,252," + (1 - gota) + ")";
            circulo(e.x + sx * er * 0.3, e.y + er * (1.1 + gota * 1.6), er * 0.16); cx.fill();
          }
        }
      });

      // boca
      var m = hf(0, -0.19);
      var w = 0.1 * m.s;
      cx.lineCap = "round";
      if (humor === "feliz") {
        cx.fillStyle = "#5b1450";
        cx.beginPath(); cx.arc(m.x, m.y - w * 0.3, w * 1.15, 0, Math.PI); cx.closePath(); cx.fill();
        cx.fillStyle = "#fb7185"; elipse(m.x, m.y + w * 0.55, w * 0.6, w * 0.32); cx.fill();
      } else if (humor === "triste") {
        cx.strokeStyle = "#3b1260"; cx.lineWidth = w * 0.3;
        cx.beginPath(); cx.arc(m.x, m.y + w * 0.9, w * 0.9, Math.PI * 1.15, Math.PI * 1.85); cx.stroke();
      } else if (humor === "pensa") {
        cx.fillStyle = "#3b1260"; elipse(m.x + w * 0.4, m.y, w * 0.32, w * 0.4); cx.fill();
      } else {
        cx.strokeStyle = "#3b1260"; cx.lineWidth = w * 0.3;
        cx.beginPath(); cx.arc(m.x, m.y - w * 0.3, w, Math.PI * 0.2, Math.PI * 0.8); cx.stroke();
      }

      // laço
      var l = hf(0.27, 0.42);
      var b = 0.14 * l.s;
      cx.save(); cx.translate(l.x, l.y); cx.rotate(-0.3);
      cx.fillStyle = "#fb7185"; cx.strokeStyle = "#9f1239"; cx.lineWidth = 1.2;
      cx.beginPath(); cx.moveTo(0, 0); cx.lineTo(-b * 1.4, -b * 0.85); cx.lineTo(-b * 1.4, b * 0.85); cx.closePath(); cx.fill(); cx.stroke();
      cx.beginPath(); cx.moveTo(0, 0); cx.lineTo(b * 1.4, -b * 0.85); cx.lineTo(b * 1.4, b * 0.85); cx.closePath(); cx.fill(); cx.stroke();
      cx.fillStyle = "#fda4af"; circulo(0, 0, b * 0.42); cx.fill(); cx.stroke();
      cx.restore();
    });

    lista.sort(function (p, q) { return q.z - p.z; }); // mais longe primeiro
    for (var i = 0; i < lista.length; i++) lista[i].f();
  }

  // ---------- Teia ----------
  var motes = [];
  for (var m = 0; m < 46; m++) {
    motes.push({ x: (Math.random() - 0.5) * 6, y: Math.random() * 3, z: (Math.random() - 0.5) * 6,
                 v: 0.05 + Math.random() * 0.12, g: Math.random() < 0.4 ? (Math.random() < 0.5 ? "0" : "1") : "", f: Math.random() * 6 });
  }

  var particulas = [];
  var textos = [];

  function explodir(x, y, n, cores, forca) {
    for (var i = 0; i < n; i++) {
      var a = Math.random() * TAU, v = (forca || 180) * (0.35 + Math.random() * 0.8);
      particulas.push({ x: x, y: y, vx: Math.cos(a) * v, vy: Math.sin(a) * v - 60, vida: 0, max: 0.7 + Math.random() * 0.7,
                        c: sortear(cores), r: 2 + Math.random() * 3.2 });
    }
  }
  function textoFlutuante(x, y, txt, cor) { textos.push({ x: x, y: y, txt: txt, cor: cor, vida: 0 }); }

  var rel = { dormindo: false };

  function desenharTeia(t) {
    var i, j, k;
    var camadas = ANEIS.length;

    // pontos projetados (uma vez por quadro)
    var pts = [], meios = [];
    var centro = P(pontoTeia(0, 0, t));
    for (j = 0; j <= camadas; j++) {
      pts[j] = []; meios[j] = [];
      var r = j === 0 ? 0 : RAIO * ANEIS[j - 1];
      for (k = 0; k < N; k++) {
        pts[j][k] = j === 0 ? centro : P(pontoTeia(angulo(k), r, t));
        if (j > 0) meios[j][k] = P(pontoTeia(angulo(k) + TAU / N / 2, r * 0.94, t));
      }
    }

    function segmentoAnel(j, k) { // curva entre o fio k e k+1, no anel j
      var a = pts[j][k], b = pts[j][(k + 1) % N], c = meios[j][k];
      cx.moveTo(a.x, a.y);
      cx.quadraticCurveTo(2 * c.x - (a.x + b.x) / 2, 2 * c.y - (a.y + b.y) / 2, b.x, b.y);
    }
    function caminhoFio(k) {
      cx.moveTo(pts[0][k].x, pts[0][k].y);
      for (var jj = 1; jj <= camadas; jj++) cx.lineTo(pts[jj][k].x, pts[jj][k].y);
    }

    // 1) fios apagados
    cx.lineCap = "round";
    cx.lineWidth = 1.1;
    cx.strokeStyle = "rgba(170,190,255,0.26)";
    cx.beginPath();
    for (k = 0; k < N; k++) caminhoFio(k);
    for (j = 1; j <= camadas; j++) for (k = 0; k < N; k++) segmentoAnel(j, k);
    cx.stroke();

    // 2) fios acesos (acertos) com brilho
    cx.save();
    cx.shadowColor = "rgba(94,234,212,0.9)";
    cx.shadowBlur = 12;
    cx.lineWidth = 2.2;
    cx.strokeStyle = "#7ff3e0";
    cx.beginPath();
    for (k = 0; k < N; k++) {
      if (G.nos[k] === 1) caminhoFio(k);
    }
    cx.stroke();
    cx.lineWidth = 1.7;
    cx.strokeStyle = "rgba(252,211,77,0.95)";
    cx.shadowColor = "rgba(252,211,77,0.8)";
    cx.beginPath();
    for (j = 1; j <= camadas; j++) {
      for (k = 0; k < N; k++) {
        if (G.nos[k] === 1 && G.nos[(k + 1) % N] === 1) segmentoAnel(j, k);
      }
    }
    cx.stroke();
    cx.restore();

    // 3) fios rompidos (erros)
    cx.save();
    cx.setLineDash([4, 6]);
    cx.lineWidth = 1.6;
    cx.strokeStyle = "rgba(251,113,133,0.75)";
    cx.beginPath();
    for (k = 0; k < N; k++) if (G.nos[k] === 2) caminhoFio(k);
    cx.stroke();
    cx.restore();

    // 4) gotinhas de orvalho
    for (j = 2; j <= camadas; j++) {
      for (k = (j % 2); k < N; k += 2) {
        var d = pts[j][k];
        var br = 0.5 + 0.5 * Math.sin(t * 2 + j * 1.7 + k);
        cx.fillStyle = "rgba(210,240,255," + (0.15 + br * 0.5) + ")";
        circulo(d.x, d.y, 1.1 + br * 1.1); cx.fill();
      }
    }

    // 5) chip central (CPU)
    var luz = G.ordem.length ? G.acertos / G.ordem.length : 0;
    var hubS = 0.2 * centro.s;
    cx.save();
    cx.shadowColor = "rgba(94,234,212," + (0.3 + luz * 0.7) + ")";
    cx.shadowBlur = 14 + luz * 22 + Math.sin(t * 3) * 3;
    cx.strokeStyle = "rgba(94,234,212,0.8)"; cx.lineWidth = 2;
    for (i = -2; i <= 2; i++) { // pinos
      var o = i * hubS * 0.32;
      cx.beginPath(); cx.moveTo(centro.x + o, centro.y - hubS * 1.25); cx.lineTo(centro.x + o, centro.y - hubS * 0.95); cx.stroke();
      cx.beginPath(); cx.moveTo(centro.x + o, centro.y + hubS * 1.25); cx.lineTo(centro.x + o, centro.y + hubS * 0.95); cx.stroke();
      cx.beginPath(); cx.moveTo(centro.x - hubS * 1.25, centro.y + o); cx.lineTo(centro.x - hubS * 0.95, centro.y + o); cx.stroke();
      cx.beginPath(); cx.moveTo(centro.x + hubS * 1.25, centro.y + o); cx.lineTo(centro.x + hubS * 0.95, centro.y + o); cx.stroke();
    }
    var gh = cx.createLinearGradient(centro.x - hubS, centro.y - hubS, centro.x + hubS, centro.y + hubS);
    gh.addColorStop(0, "#1b2a5e"); gh.addColorStop(1, "#0f1538");
    cx.fillStyle = gh; retArred(centro.x - hubS, centro.y - hubS * 0.8, hubS * 2, hubS * 1.6, hubS * 0.28); cx.fill(); cx.stroke();
    cx.restore();
    cx.fillStyle = "rgba(94," + (200 + luz * 34) + ",212,1)";
    cx.font = "900 " + Math.max(9, hubS * 0.62) + "px " + "system-ui, sans-serif";
    cx.textAlign = "center"; cx.textBaseline = "middle";
    cx.fillText("CPU", centro.x, centro.y);

    // 6) nós (um chip por fio) + Fia, em ordem de profundidade
    var itens = [];
    for (k = 0; k < N; k++) {
      (function (k) {
        var p = pts[camadas][k];
        itens.push({ z: p.z, f: function () { desenharNo(k, p, t); } });
      })(k);
    }
    var bf = proj(fia.x, alturaTeia(Math.hypot(fia.x, fia.z)), fia.z, 0, 0, 0);
    itens.push({ z: bf.z, f: function () { desenharFia(t); } });
    itens.sort(function (a, b) { return b.z - a.z; });
    for (i = 0; i < itens.length; i++) itens[i].f();
  }

  function desenharNo(k, p, t) {
    var st = G.nos[k] || 0;
    var atual = G.estado === "quiz" && G.pos === k && !G.respondido;
    var s = 0.095 * p.s;
    var x = p.x, y = p.y;
    var usado = G.estado === "quiz" ? k < G.ordem.length : true;

    cx.save();
    if (st === 1) { cx.shadowColor = "rgba(94,234,212,0.95)"; cx.shadowBlur = 16; }
    if (st === 2) { cx.shadowColor = "rgba(251,113,133,0.8)"; cx.shadowBlur = 12; }
    if (atual) { cx.shadowColor = "rgba(255,255,255,0.9)"; cx.shadowBlur = 14 + Math.sin(t * 5) * 6; }

    // pinos do chip
    cx.strokeStyle = st === 1 ? "#7ff3e0" : st === 2 ? "#fb7185" : "rgba(170,190,255,0.55)";
    cx.lineWidth = 1.5;
    for (var i = -1; i <= 1; i++) {
      var o = i * s * 0.55;
      cx.beginPath(); cx.moveTo(x + o, y - s * 1.35); cx.lineTo(x + o, y - s * 1); cx.stroke();
      cx.beginPath(); cx.moveTo(x + o, y + s * 1.35); cx.lineTo(x + o, y + s * 1); cx.stroke();
    }
    var fill = "rgba(18,18,58,0.92)";
    if (st === 1) fill = "#5eead4";
    if (st === 2) fill = "#fb7185";
    if (atual) fill = "rgba(60,50,140,0.95)";
    if (!usado) fill = "rgba(18,18,58,0.4)";
    cx.fillStyle = fill; retArred(x - s, y - s, s * 2, s * 2, s * 0.35); cx.fill();
    cx.lineWidth = atual ? 2.4 : 1.6;
    cx.strokeStyle = atual ? "#fff" : st === 1 ? "#d9fff8" : st === 2 ? "#ffd0d6" : "rgba(170,190,255,0.7)";
    cx.stroke();
    cx.restore();

    cx.fillStyle = st === 0 ? "#dfe3ff" : "#08121c";
    cx.font = "900 " + Math.max(8, s * 1.1) + "px system-ui, sans-serif";
    cx.textAlign = "center"; cx.textBaseline = "middle";
    cx.fillText(st === 1 ? "✓" : st === 2 ? "✕" : String(k + 1), x, y + 0.5);
  }

  function desenharFundo(t) {
    for (var i = 0; i < motes.length; i++) {
      var m = motes[i];
      var p = proj(m.x, m.y + ((t * m.v) % 3), m.z);
      if (p.s <= 0) continue;
      var a = 0.12 + 0.28 * (0.5 + 0.5 * Math.sin(t * 1.3 + m.f));
      if (m.g) {
        cx.fillStyle = "rgba(94,234,212," + a + ")";
        cx.font = "700 " + (0.09 * p.s) + "px ui-monospace, Menlo, monospace";
        cx.textAlign = "center"; cx.textBaseline = "middle";
        cx.fillText(m.g, p.x, p.y);
      } else {
        cx.fillStyle = "rgba(200,190,255," + a + ")";
        circulo(p.x, p.y, 0.012 * p.s + 0.6); cx.fill();
      }
    }
  }

  function desenharParticulas(dt) {
    var i;
    cx.save();
    cx.globalCompositeOperation = "lighter";
    for (i = particulas.length - 1; i >= 0; i--) {
      var p = particulas[i];
      p.vida += dt;
      if (p.vida >= p.max) { particulas.splice(i, 1); continue; }
      p.vy += 380 * dt;
      p.x += p.vx * dt; p.y += p.vy * dt;
      cx.globalAlpha = 1 - p.vida / p.max;
      cx.fillStyle = p.c;
      circulo(p.x, p.y, p.r); cx.fill();
    }
    cx.restore();
    cx.globalAlpha = 1;
    for (i = textos.length - 1; i >= 0; i--) {
      var tx = textos[i];
      tx.vida += dt;
      if (tx.vida > 1.4) { textos.splice(i, 1); continue; }
      cx.globalAlpha = 1 - Math.pow(tx.vida / 1.4, 2);
      cx.fillStyle = tx.cor;
      cx.font = "900 " + 22 + "px system-ui, sans-serif";
      cx.textAlign = "center"; cx.textBaseline = "middle";
      cx.shadowColor = "rgba(0,0,0,0.6)"; cx.shadowBlur = 6;
      cx.fillText(tx.txt, tx.x, tx.y - tx.vida * 60);
      cx.shadowBlur = 0;
    }
    cx.globalAlpha = 1;
  }

  // ---------- laço principal ----------
  var tAnterior = 0;
  var ponteiro = { x: -1, y: -1 };

  function quadro(ms) {
    requestAnimationFrame(quadro);
    var t = ms / 1000;
    var dt = Math.min(0.05, t - tAnterior || 0.016);
    tAnterior = t;
    if (!W || !telaJogar.classList.contains("visivel")) return;

    var calmo = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;

    // câmera suave
    var k = Math.min(1, dt * 2.2);
    cam.D += (camAlvo.D - cam.D) * k;
    cam.pitch += (camAlvo.pitch - cam.pitch) * k;
    cam.cy += (camAlvo.cy - cam.cy) * k;
    if (!arrasto.ativo) { arrasto.yaw *= 1 - Math.min(1, dt * 0.5); arrasto.pitch *= 1 - Math.min(1, dt * 0.5); }
    cam.yaw = (calmo ? 0 : Math.sin(t * 0.28) * 0.42) + arrasto.yaw;
    pitchEf = limitar(cam.pitch + arrasto.pitch, 0.12, 1.3);
    F = Math.min(W, H * 1.15) * 1.15;

    // Fia: caminhar
    if (fia.andando) {
      fia.prog += dt / fia.dur;
      var q = Math.min(1, fia.prog);
      var e = q < 0.5 ? 2 * q * q : 1 - Math.pow(-2 * q + 2, 2) / 2;
      fia.x = fia.de[0] + (fia.para[0] - fia.de[0]) * e;
      fia.z = fia.de[1] + (fia.para[1] - fia.de[1]) * e;
      if (Math.floor(fia.prog * 6) !== Math.floor((fia.prog - dt / fia.dur) * 6)) somPulo();
      if (fia.prog >= 1) {
        fia.andando = false; fia.x = fia.para[0]; fia.z = fia.para[1];
        var cb = fia.aoChegar; fia.aoChegar = null;
        if (cb) cb();
      }
    }
    fia.w += ((fia.andando ? 1 : 0) - fia.w) * Math.min(1, dt * 8);

    // humor e olhar
    var agora = performance.now() / 1000;
    if (fia.humorAte && agora > fia.humorAte) {
      fia.humor = G.estado === "quiz" && !G.respondido ? "pensa" : "idle";
      fia.humorAte = 0;
    }
    fia.proxPisca -= dt;
    if (fia.proxPisca <= 0) { fia.pisca = 0.14; fia.proxPisca = 2.2 + Math.random() * 3; }
    if (fia.pisca > 0) fia.pisca -= dt;
    var rect = cv.getBoundingClientRect();
    if (ponteiro.x >= 0) {
      var alvoX = limitar((ponteiro.x - rect.left - fia.tela.x) / 260, -1, 1);
      var alvoY = limitar((ponteiro.y - rect.top - fia.tela.y) / 260, -1, 1);
      fia.olhaX += (alvoX - fia.olhaX) * Math.min(1, dt * 6);
      fia.olhaY += (alvoY - fia.olhaY) * Math.min(1, dt * 6);
      fia.giro += (alvoX * 0.3 - fia.giro) * Math.min(1, dt * 4);
    }

    // barra do bônus de velocidade
    if (G.estado === "quiz" && !G.respondido) {
      var rest = limitar(1 - (performance.now() - G.t0) / 20000, 0, 1);
      barraTempo.style.transform = "scaleX(" + rest + ")";
    }

    // desenhar
    cx.setTransform(dpr, 0, 0, dpr, 0, 0);
    cx.clearRect(0, 0, W, H);
    desenharFundo(t);
    desenharTeia(t);
    desenharParticulas(dt);
  }

  // =====================================================================
  // 6. ELEMENTOS DA PÁGINA
  // =====================================================================
  var telaJogar = $("tela-jogar");
  var telaEstudar = $("tela-estudar");
  var abaJogar = $("aba-jogar");
  var abaEstudar = $("aba-estudar");
  var vMenu = $("v-menu"), vQuiz = $("v-quiz"), vFim = $("v-fim");
  var elBalao = $("balao"), elBalaoTexto = $("balao-texto");
  var elOpcoes = $("opcoes"), elPergunta = $("pergunta"), elGrupo = $("etq-grupo");
  var elMsg = $("mensagem"), elExp = $("explicacao");
  var btnProxima = $("btn-proxima"), btnDica = $("btn-dica");
  var barraTempo = $("tempo-barra");
  var elPips = $("pips");

  function falar(txt) {
    elBalaoTexto.textContent = txt;
    elBalao.classList.remove("pop");
    void elBalao.offsetWidth;
    elBalao.classList.add("pop");
  }

  function mostrarVista(v) {
    [vMenu, vQuiz, vFim].forEach(function (el) { el.classList.remove("ativa"); });
    v.classList.add("ativa");
  }

  // =====================================================================
  // 7. LÓGICA DO JOGO
  // =====================================================================
  var FRASES_OK = ["Isso! Mais um fio aceso!", "Arrasou! A teia está brilhando!", "Certinho! Você manja disso.", "Uhul! Esse eu já sabia que você sabia!", "Perfeito! Segue o fio!"];
  var FRASES_ERRO = ["Ops! Esse fio arrebentou...", "Quase! Leia a explicação.", "Tudo bem, errar faz parte de aprender.", "Hmm, vamos guardar essa para revisar."];
  var FRASES_PENSA = ["Hmm... qual será?", "Leia a pista com calma.", "Será que você sabe essa?", "Estou de olho em você!", "Confio em você!"];

  function novoJogo(indices, revisao) {
    G.ordem = embaralhar(indices.slice());
    G.pos = 0;
    G.nos = [];
    for (var i = 0; i < N; i++) G.nos.push(0);
    G.acertos = 0; G.pontos = 0; G.combo = 0; G.melhorCombo = 0;
    G.erros = []; G.dicas = 3; G.respondido = false;
    G.revisao = !!revisao;
    G.estado = "quiz";
    particulas.length = 0; textos.length = 0;

    // pips de progresso
    elPips.innerHTML = "";
    for (var p = 0; p < N; p++) {
      var pip = document.createElement("i");
      if (p >= G.ordem.length) pip.style.display = "none";
      elPips.appendChild(pip);
    }
    elPips.style.gridTemplateColumns = "repeat(" + G.ordem.length + ", 1fr)";

    camAlvo.D = 5.1; camAlvo.pitch = 0.95; camAlvo.cy = 0.55;
    mostrarVista(vQuiz);
    mostrarPergunta();
  }

  function montarOpcoes(idx) {
    var certa = palavras[idx];
    var mesmos = [], outros = [];
    palavras.forEach(function (p, i) {
      if (i === idx) return;
      (p.grupo === certa.grupo ? mesmos : outros).push(i);
    });
    embaralhar(mesmos); embaralhar(outros);
    var erradas = mesmos.slice(0, 2);                 // 2 "pegadinhas" do mesmo assunto
    var resto = embaralhar(outros.concat(mesmos.slice(2)));
    while (erradas.length < 3) erradas.push(resto.shift());
    return embaralhar([idx].concat(erradas));
  }

  function atualizarHud() {
    $("hud-num").textContent = (G.pos + 1) + "/" + G.ordem.length;
    $("hud-pontos").textContent = G.pontos;
    $("hud-combo").textContent = G.combo > 1 ? "x" + G.combo : G.combo;
    $("hud-combo-caixa").classList.toggle("quente", G.combo >= 3);
    var pips = elPips.children;
    for (var i = 0; i < G.ordem.length; i++) {
      var st = G.nos[i];
      pips[i].className = st === 1 ? "ok" : st === 2 ? "erro" : (i === G.pos && G.estado === "quiz" ? "atual" : "");
    }
    btnDica.textContent = "Dica (" + G.dicas + ")";
    btnDica.disabled = G.dicas <= 0 || G.respondido || G.dicaUsada;
  }

  function mostrarPergunta() {
    var idx = G.ordem[G.pos];
    var p = palavras[idx];
    G.opcoes = montarOpcoes(idx);
    G.respondido = false;
    G.dicaUsada = false;
    G.t0 = performance.now();

    elGrupo.textContent = GRUPOS[p.grupo];
    elPergunta.textContent = p.pista;
    elMsg.textContent = "";
    elExp.className = "";
    elExp.textContent = "";
    btnProxima.style.display = "none";
    barraTempo.style.transform = "scaleX(1)";

    elOpcoes.innerHTML = "";
    G.opcoes.forEach(function (oi, n) {
      var b = document.createElement("button");
      var l = document.createElement("span");
      l.className = "letra"; l.textContent = "ABCD".charAt(n);
      var tx = document.createElement("span");
      tx.textContent = palavras[oi].nome;
      b.appendChild(l); b.appendChild(tx);
      b.onclick = function () { responder(n); };
      elOpcoes.appendChild(b);
    });

    atualizarHud();
    definirHumor("pensa", 0);
    falar(sortear(FRASES_PENSA));

    // a Fia vai até o fio da pergunta
    var alvo = nosPosicao(G.pos);
    andarPara(alvo[0], alvo[1], 1.0, null);
  }

  function responder(n) {
    if (G.respondido || G.estado !== "quiz") return;
    G.respondido = true;
    var idx = G.ordem[G.pos];
    var escolhido = G.opcoes[n];
    var botoes = elOpcoes.children;
    var certo = escolhido === idx;

    for (var i = 0; i < botoes.length; i++) {
      botoes[i].disabled = true;
      if (G.opcoes[i] === idx) botoes[i].classList.add("certa");
    }

    var f = fia.tela;
    if (certo) {
      var rapidez = limitar(1 - (performance.now() - G.t0) / 20000, 0, 1);
      var base = G.dicaUsada ? 60 : 100;
      G.combo++;
      G.melhorCombo = Math.max(G.melhorCombo, G.combo);
      var ganho = base + Math.round(rapidez * 50) + Math.min(G.combo - 1, 5) * 10;
      G.pontos += ganho;
      G.acertos++;
      G.nos[G.pos] = 1;
      elMsg.textContent = "Acertou! +" + ganho + " pontos";
      elMsg.style.color = "#7ff3e0";
      definirHumor("feliz", 2.4);
      falar(sortear(FRASES_OK));
      explodir(f.x, f.y - 30, 46, ["#5eead4", "#fcd34d", "#f0abfc", "#ffffff"], 230);
      textoFlutuante(f.x, f.y - 70, "+" + ganho, "#fcd34d");
      somAcerto();
    } else {
      botoes[n].classList.add("errada");
      G.combo = 0;
      G.nos[G.pos] = 2;
      G.erros.push(idx);
      elMsg.textContent = "Quase! A resposta certa está em verde.";
      elMsg.style.color = "#ffc2cb";
      definirHumor("triste", 2.6);
      falar(sortear(FRASES_ERRO));
      explodir(f.x, f.y - 20, 18, ["#fb7185", "#9f1239", "#c4b5fd"], 120);
      somErro();
    }

    elExp.textContent = palavras[idx].explicacao;
    elExp.className = "mostra";
    btnProxima.textContent = G.pos === G.ordem.length - 1 ? "Ver resultado" : "Próxima";
    btnProxima.style.display = "inline-block";
    barraTempo.style.transform = "scaleX(0)";
    atualizarHud();
  }

  function usarDica() {
    if (G.respondido || G.dicas <= 0 || G.dicaUsada) return;
    G.dicas--; G.dicaUsada = true;
    var idx = G.ordem[G.pos];
    var candidatas = [];
    G.opcoes.forEach(function (oi, n) { if (oi !== idx) candidatas.push(n); });
    embaralhar(candidatas);
    candidatas.slice(0, 2).forEach(function (n) { elOpcoes.children[n].classList.add("apagada"); });
    somClique();
    falar("Tirei duas opções para você!");
    atualizarHud();
  }

  function proxima() {
    if (!G.respondido) return;
    somClique();
    if (G.pos < G.ordem.length - 1) {
      G.pos++;
      mostrarPergunta();
    } else {
      mostrarFim();
    }
  }

  function mostrarFim() {
    G.estado = "fim";
    var total = G.ordem.length;
    var pct = G.acertos / total;
    var titulo, texto;
    if (G.acertos === total) { titulo = "Arquiteta Mestre"; texto = "Teia perfeita! Você dominou todos os termos desta rodada."; }
    else if (pct >= 0.75) { titulo = "Tecelã Experiente"; texto = "Falta pouquinho! Revise os termos abaixo e a teia fica completa."; }
    else if (pct >= 0.5) { titulo = "Tecelã"; texto = "Bom caminho! Dê uma olhada no modo Estudo e tente de novo."; }
    else { titulo = "Aprendiz de Teia"; texto = "Todo mundo começa assim. Estude os cartões e volte para tecer de novo."; }

    $("fim-titulo").textContent = titulo;
    $("fim-texto").textContent = texto;
    $("fim-acertos").textContent = G.acertos + "/" + total;
    $("fim-pontos").textContent = G.pontos;
    $("fim-seq").textContent = G.melhorCombo;

    var estrelas = pct >= 0.9 ? 3 : pct >= 0.6 ? 2 : pct >= 0.3 ? 1 : 0;
    var els = $("estrelas").children;
    for (var i = 0; i < 3; i++) els[i].classList.remove("cheia");
    for (var s = 0; s < estrelas; s++) (function (s) { setTimeout(function () { els[s].classList.add("cheia"); somClique(); }, 400 + s * 350); })(s);

    var caixa = $("fim-erros");
    caixa.innerHTML = "";
    G.erros.forEach(function (idx) {
      var d = document.createElement("div");
      d.className = "erro-item";
      var b = document.createElement("b"); b.textContent = palavras[idx].nome + ": ";
      d.appendChild(b);
      d.appendChild(document.createTextNode(palavras[idx].explicacao));
      caixa.appendChild(d);
    });
    $("btn-so-erros").style.display = G.erros.length ? "inline-block" : "none";

    if (!G.revisao) {
      var melhor = ler("fia_melhor", 0);
      if (G.pontos > melhor) guardar("fia_melhor", G.pontos);
    }

    camAlvo.D = 3.7; camAlvo.pitch = 0.6; camAlvo.cy = 0.58;
    andarPara(0, 0, 1.4, function () {
      definirHumor(G.acertos >= total / 2 ? "feliz" : "triste", 5);
    });
    falar(G.acertos === total ? "A teia ficou completa! Obrigada!" : "Obrigada por me ajudar!");
    somFim();
    if (G.acertos >= total * 0.6) {
      var rep = 0;
      var iv = setInterval(function () {
        explodir(fia.tela.x + (Math.random() - 0.5) * 140, fia.tela.y - 60, 30, ["#5eead4", "#fcd34d", "#f0abfc", "#fff"], 260);
        if (++rep > 4) clearInterval(iv);
      }, 450);
    }
    mostrarVista(vFim);
  }

  function irParaMenu() {
    G.estado = "menu";
    for (var i = 0; i < N; i++) G.nos[i] = 0;
    G.acertos = 0; G.ordem = [];
    camAlvo.D = 3.3; camAlvo.pitch = 0.45; camAlvo.cy = 0.56;
    andarPara(0, 0, 1.0, null);
    definirHumor("idle", 0);
    falar("Oi! Eu sou a Fia. Me ajuda com a teia?");
    atualizarRecorde();
    mostrarVista(vMenu);
  }

  function atualizarRecorde() {
    var m = ler("fia_melhor", 0);
    $("recorde").textContent = m > 0 ? "Seu recorde: " + m + " pontos" : "";
  }

  // =====================================================================
  // 8. MODO ESTUDAR
  // =====================================================================
  var sei = ler("fia_sei", []);
  var filtro = "todos";
  var estudoPronto = false;

  function montarFiltros() {
    var caixa = $("filtros");
    caixa.innerHTML = "";
    var itens = [["todos", "Todos"], ["cpu", GRUPOS.cpu], ["mem", GRUPOS.mem], ["tra", GRUPOS.tra], ["sis", GRUPOS.sis], ["pendente", "Ainda não sei"]];
    itens.forEach(function (it) {
      var b = document.createElement("button");
      b.textContent = it[1];
      if (filtro === it[0]) b.className = "ativo";
      b.onclick = function () { filtro = it[0]; montarFiltros(); montarCartoes(); somClique(); };
      caixa.appendChild(b);
    });
  }

  function atualizarDominio() {
    $("dominio-texto").textContent = sei.length + " de " + TOTAL + " dominados";
    $("dominio-barra").style.width = (sei.length / TOTAL * 100) + "%";
  }

  function montarCartoes() {
    var caixa = $("cartoes");
    caixa.innerHTML = "";
    palavras.forEach(function (p, i) {
      var sabe = sei.indexOf(i) >= 0;
      if (filtro === "pendente" && sabe) return;
      if (filtro !== "todos" && filtro !== "pendente" && p.grupo !== filtro) return;

      var c = document.createElement("div");
      c.className = "cartao" + (sabe ? " sabe" : "");
      var num = (i < 9 ? "0" : "") + (i + 1);
      c.innerHTML =
        '<div class="inclina"><div class="gira">' +
          '<div class="face frente">' +
            '<div class="topo-cartao"><span class="num-cartao">#' + num + '</span><span class="etiqueta">' + GRUPOS[p.grupo] + '</span></div>' +
            '<p>' + p.pista + '</p>' +
            '<span class="virar">clique para ver a resposta</span>' +
          '</div>' +
          '<div class="face verso">' +
            '<div class="topo-cartao"><span class="num-cartao">#' + num + '</span><span class="etiqueta">' + GRUPOS[p.grupo] + '</span></div>' +
            '<div class="titulo-cartao">' + p.nome + '</div>' +
            '<p>' + p.explicacao + '</p>' +
            '<button class="btn-sei">' + (sabe ? "Já sei ✓" : "Marcar como já sei") + '</button>' +
          '</div>' +
        '</div></div>';

      var gira = c.querySelector(".gira");
      var inclina = c.querySelector(".inclina");
      var btn = c.querySelector(".btn-sei");

      gira.onclick = function () { c.classList.toggle("virado"); somClique(); };
      btn.onclick = function (ev) {
        ev.stopPropagation();
        var pos = sei.indexOf(i);
        if (pos >= 0) sei.splice(pos, 1); else sei.push(i);
        guardar("fia_sei", sei);
        var agoraSabe = sei.indexOf(i) >= 0;
        c.classList.toggle("sabe", agoraSabe);
        btn.textContent = agoraSabe ? "Já sei ✓" : "Marcar como já sei";
        atualizarDominio();
        if (agoraSabe) somAcerto();
      };
      // inclina o cartão seguindo o mouse
      c.addEventListener("pointermove", function (ev) {
        if (ev.pointerType === "touch") return;
        var r = c.getBoundingClientRect();
        var px = (ev.clientX - r.left) / r.width - 0.5;
        var py = (ev.clientY - r.top) / r.height - 0.5;
        inclina.style.setProperty("--rx", (px * 14) + "deg");
        inclina.style.setProperty("--ry", (-py * 14) + "deg");
      });
      c.addEventListener("pointerleave", function () {
        inclina.style.setProperty("--rx", "0deg");
        inclina.style.setProperty("--ry", "0deg");
      });
      caixa.appendChild(c);
    });
    atualizarDominio();
  }

  // =====================================================================
  // 9. ABAS, EVENTOS E INÍCIO
  // =====================================================================
  function irParaJogar() {
    telaJogar.classList.add("visivel");
    telaEstudar.classList.remove("visivel");
    abaJogar.classList.add("ativa");
    abaEstudar.classList.remove("ativa");
    setTimeout(ajustar, 0);
  }

  function irParaEstudar() {
    telaJogar.classList.remove("visivel");
    telaEstudar.classList.add("visivel");
    abaJogar.classList.remove("ativa");
    abaEstudar.classList.add("ativa");
    if (!estudoPronto) { montarFiltros(); montarCartoes(); estudoPronto = true; }
    window.scrollTo(0, 0);
  }

  function todosIndices() { var a = []; for (var i = 0; i < TOTAL; i++) a.push(i); return a; }

  abaJogar.onclick = irParaJogar;
  abaEstudar.onclick = irParaEstudar;
  $("btn-som").onclick = function () {
    somLigado = !somLigado;
    this.textContent = "Som: " + (somLigado ? "on" : "off");
    if (somLigado) somClique();
  };
  $("btn-comecar").onclick = function () { somClique(); novoJogo(todosIndices(), false); };
  $("btn-ir-estudar").onclick = irParaEstudar;
  $("btn-fim-estudar").onclick = irParaEstudar;
  $("btn-de-novo").onclick = function () { somClique(); novoJogo(todosIndices(), false); };
  $("btn-so-erros").onclick = function () { somClique(); novoJogo(G.erros.slice(), true); };
  $("btn-reiniciar").onclick = function () { somClique(); irParaMenu(); };
  btnProxima.onclick = proxima;
  btnDica.onclick = usarDica;

  document.addEventListener("keydown", function (ev) {
    if (!telaJogar.classList.contains("visivel") || G.estado !== "quiz") return;
    var k = ev.key;
    if (k >= "1" && k <= "4") { responder(Number(k) - 1); }
    else if (k === "Enter" || k === " " || k === "ArrowRight") {
      if (G.respondido) { ev.preventDefault(); proxima(); }
    }
  });

  // arrastar para girar a teia
  cv.addEventListener("pointerdown", function (ev) {
    arrasto.ativo = true; arrasto.x = ev.clientX; arrasto.y = ev.clientY;
    try { cv.setPointerCapture(ev.pointerId); } catch (e) {}
  });
  cv.addEventListener("pointermove", function (ev) {
    if (!arrasto.ativo) return;
    arrasto.yaw += (ev.clientX - arrasto.x) * 0.008;
    arrasto.pitch = limitar(arrasto.pitch + (ev.clientY - arrasto.y) * 0.004, -0.5, 0.5);
    arrasto.x = ev.clientX; arrasto.y = ev.clientY;
  });
  function soltar() { arrasto.ativo = false; }
  cv.addEventListener("pointerup", soltar);
  cv.addEventListener("pointercancel", soltar);
  window.addEventListener("pointermove", function (ev) { ponteiro.x = ev.clientX; ponteiro.y = ev.clientY; });

  window.addEventListener("resize", ajustar);
  if (window.ResizeObserver) new ResizeObserver(ajustar).observe(cv.parentNode);

  // começa tudo
  for (var z = 0; z < N; z++) G.nos.push(0);
  irParaJogar();
  atualizarRecorde();
  falar("Oi! Eu sou a Fia. Me ajuda com a teia?");
  requestAnimationFrame(quadro);

  // gancho para testes automáticos (não afeta o jogo)
  window.__fia = { G: G, cam: cam, camAlvo: camAlvo, fia: fia };
})();
