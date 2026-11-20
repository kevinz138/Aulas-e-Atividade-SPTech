// Fia e os Fios da Arquitetura - script do jogo

// Lista das 16 palavras: nome (para mostrar), resposta (grafia da atividade),
// pista (até 15 palavras) e explicacao (aparece depois de responder)
var palavras = [
  {
    nome: "CPU", resposta: "CPU",
    pista: "O cérebro do computador, executa as instruções dos programas.",
    explicacao: "CPU significa Unidade Central de Processamento. Ela é formada pela ULA, pela UC e pelos registradores."
  },
  {
    nome: "ULA", resposta: "ULA",
    pista: "Parte da CPU que faz as contas e as operações lógicas.",
    explicacao: "ULA é a Unidade Lógica e Aritmética. Ela faz somas, subtrações, comparações e operações lógicas."
  },
  {
    nome: "UC (Unidade de Controle)", resposta: "UC",
    pista: "Parte da CPU que comanda o que cada componente deve fazer.",
    explicacao: "A Unidade de Controle busca e interpreta as instruções e coordena os outros componentes."
  },
  {
    nome: "Registradores", resposta: "REGISTRADORES",
    pista: "Minúsculas memórias dentro do processador, rapidíssimas, guardam dados do momento.",
    explicacao: "São as memórias mais rápidas do computador e ficam dentro da CPU. Guardam dados e resultados do momento."
  },
  {
    nome: "RAM", resposta: "RAM",
    pista: "Memória principal e volátil onde ficam os programas em uso.",
    explicacao: "RAM é a memória de acesso aleatório. Ela é volátil: quando o computador desliga, tudo é perdido."
  },
  {
    nome: "ROM", resposta: "ROM",
    pista: "Memória que só é lida e não perde os dados sem energia.",
    explicacao: "ROM é a memória somente de leitura. Ela é não volátil e guarda programas fixos, como os de inicialização."
  },
  {
    nome: "EEPROM", resposta: "EEPROM",
    pista: "Memória não volátil que pode ser apagada com eletricidade, byte a byte.",
    explicacao: "EEPROM é uma ROM programável e apagável eletricamente. Dá para regravar sem tirar o chip da placa."
  },
  {
    nome: "Flash", resposta: "FLASH",
    pista: "Memória não volátil usada em pen drives e cartões SD.",
    explicacao: "A memória Flash é parecida com a EEPROM, mas é apagada em blocos. Por isso é rápida e barata."
  },
  {
    nome: "Cache", resposta: "CACHE",
    pista: "Memória pequena e veloz perto da CPU, guarda o que é muito usado.",
    explicacao: "A cache fica entre a CPU e a RAM. Ela deixa o acesso aos dados mais usados bem mais rápido."
  },
  {
    nome: "Memória de massa (armazenamento)", resposta: "MEMORIADEMASSA",
    pista: "Onde seus arquivos ficam de forma permanente, como no HD ou SSD.",
    explicacao: "É a memória de grande capacidade e não volátil, como HD e SSD. É mais lenta que a RAM."
  },
  {
    nome: "DMA", resposta: "DMA",
    pista: "Deixa dispositivos trocarem dados com a RAM sem incomodar a CPU.",
    explicacao: "DMA é o Acesso Direto à Memória. A CPU fica livre para fazer outras tarefas enquanto os dados são transferidos."
  },
  {
    nome: "Address bus (barramento de endereço)", resposta: "ADDRESSBUS",
    pista: "Caminho que indica qual posição da memória será lida ou escrita.",
    explicacao: "O barramento de endereço leva o endereço da CPU até a memória. Ele só vai em um sentido."
  },
  {
    nome: "Data bus (barramento de dados)", resposta: "DATABUS",
    pista: "Caminho de ida e volta por onde o conteúdo viaja entre os componentes.",
    explicacao: "O barramento de dados transporta os dados e funciona nos dois sentidos: lê e escreve."
  },
  {
    nome: "Microcontrolador", resposta: "MICROCONTROLADOR",
    pista: "Chip pequeno que junta processador, memória e portas, usado em aparelhos embarcados.",
    explicacao: "É um computador inteiro em um só chip. Aparece em eletrodomésticos, carros e placas como o Arduino."
  },
  {
    nome: "Dual core", resposta: "DUALCORE",
    pista: "Processador com dois núcleos trabalhando juntos.",
    explicacao: "Dual core quer dizer dois núcleos. Eles podem executar duas tarefas ao mesmo tempo."
  },
  {
    nome: "Quad core", resposta: "QUADCORE",
    pista: "Processador com quatro núcleos trabalhando juntos.",
    explicacao: "Quad core quer dizer quatro núcleos. Dá para executar até quatro tarefas ao mesmo tempo."
  }
];

// Variáveis do jogo
var ordem = [];        // ordem embaralhada das perguntas
var posicao = 0;       // em qual pergunta estamos
var acertos = 0;       // quantas acertou
var opcoes = [];       // as 4 opções da pergunta atual
var escolhida = -1;    // número da opção que o jogador clicou
var conferiu = false;  // true depois de clicar em Conferir

// Pegando os elementos da página
var abaJogar = document.getElementById("aba-jogar");
var abaEstudar = document.getElementById("aba-estudar");
var telaJogar = document.getElementById("tela-jogar");
var telaEstudar = document.getElementById("tela-estudar");
var elContador = document.getElementById("contador");
var elFioCheio = document.getElementById("fio-cheio");
var elFiaAndando = document.getElementById("fia-andando");
var elNumero = document.getElementById("numero");
var elPergunta = document.getElementById("pergunta");
var elOpcoes = document.getElementById("opcoes");
var elMensagem = document.getElementById("mensagem");
var elExplicacao = document.getElementById("explicacao");
var botaoConferir = document.getElementById("btn-conferir");
var botaoProxima = document.getElementById("btn-proxima");
var botaoReiniciar = document.getElementById("btn-reiniciar");
var elCartoes = document.getElementById("cartoes");

// Função para embaralhar uma lista
function embaralhar(lista) {
  for (var i = lista.length - 1; i > 0; i--) {
    var j = Math.floor(Math.random() * (i + 1));
    var guardado = lista[i];
    lista[i] = lista[j];
    lista[j] = guardado;
  }
  return lista;
}

// Atualiza contador e o fio de progresso
function atualizarPlacar() {
  var total = palavras.length;
  elContador.textContent = acertos + " de " + total + " palavras";

  // a Fia anda conforme as perguntas respondidas
  var respondidas = posicao;
  if (conferiu) {
    respondidas = posicao + 1;
  }
  var porcentagem = (respondidas / total) * 100;
  elFioCheio.style.width = porcentagem + "%";
  elFiaAndando.style.left = porcentagem + "%";
}

// Mostra uma pergunta nova
function mostrarPergunta() {
  var certa = palavras[ordem[posicao]];

  // monta as 4 opções: a certa + 3 erradas
  var outras = [];
  for (var i = 0; i < palavras.length; i++) {
    if (i != ordem[posicao]) {
      outras.push(palavras[i]);
    }
  }
  outras = embaralhar(outras);

  opcoes = [certa, outras[0], outras[1], outras[2]];
  opcoes = embaralhar(opcoes);

  escolhida = -1;
  conferiu = false;

  elNumero.textContent = "Pergunta " + (posicao + 1) + " de " + palavras.length;
  elPergunta.textContent = certa.pista;
  elMensagem.textContent = "";
  elExplicacao.style.display = "none";
  botaoProxima.style.display = "none";
  botaoConferir.style.display = "inline-block";

  // cria os botões das opções
  elOpcoes.innerHTML = "";
  for (var k = 0; k < opcoes.length; k++) {
    var botao = document.createElement("button");
    botao.textContent = opcoes[k].nome;
    botao.id = "opcao-" + k;
    botao.onclick = function () {
      escolher(this.id);
    };
    elOpcoes.appendChild(botao);
  }

  atualizarPlacar();
}

// Quando o jogador clica numa opção
function escolher(id) {
  if (conferiu) {
    return;
  }

  escolhida = Number(id.replace("opcao-", ""));

  // tira o destaque de todas e coloca na clicada
  for (var i = 0; i < opcoes.length; i++) {
    document.getElementById("opcao-" + i).className = "";
  }
  document.getElementById("opcao-" + escolhida).className = "selecionada";
  elMensagem.textContent = "";
}

// Botão Conferir
function conferir() {
  if (conferiu) {
    return;
  }

  if (escolhida == -1) {
    elMensagem.textContent = "Escolha uma opção primeiro! 😉";
    return;
  }

  conferiu = true;

  var certa = palavras[ordem[posicao]];

  // marca a opção certa de verde e a errada de vermelho
  for (var i = 0; i < opcoes.length; i++) {
    if (opcoes[i].resposta == certa.resposta) {
      document.getElementById("opcao-" + i).className = "certa";
    }
  }

  if (opcoes[escolhida].resposta == certa.resposta) {
    acertos++;
    elMensagem.textContent = "🎉 Acertou! A Fia tecendo feliz!";
  } else {
    document.getElementById("opcao-" + escolhida).className = "errada";
    elMensagem.textContent = "😅 Quase! A resposta certa está em verde.";
  }

  // mostra a explicação para ajudar a estudar
  elExplicacao.textContent = "💡 " + certa.explicacao;
  elExplicacao.style.display = "block";

  botaoConferir.style.display = "none";

  if (posicao == palavras.length - 1) {
    mostrarFim();
  } else {
    botaoProxima.style.display = "inline-block";
  }

  atualizarPlacar();
}

// Botão Próxima
function proxima() {
  posicao++;
  mostrarPergunta();
}

// Mensagem final
function mostrarFim() {
  var total = palavras.length;
  var texto = "🏁 Fim! Você acertou " + acertos + " de " + total + " palavras. ";

  if (acertos == total) {
    texto = texto + "Perfeito! A teia da Fia ficou completa! 🕸️✨";
  } else if (acertos >= 12) {
    texto = texto + "Arrasou! Falta pouquinho! 💪";
  } else {
    texto = texto + "Dê uma olhada na aba Estudar e tente de novo! 📖";
  }

  elMensagem.textContent = texto;
}

// Botão Reiniciar
function reiniciar() {
  var numeros = [];
  for (var i = 0; i < palavras.length; i++) {
    numeros.push(i);
  }
  ordem = embaralhar(numeros);
  posicao = 0;
  acertos = 0;
  mostrarPergunta();
}

// ----- Modo estudar -----
function criarCartoes() {
  elCartoes.innerHTML = "";

  for (var i = 0; i < palavras.length; i++) {
    var cartao = document.createElement("div");
    cartao.className = "cartao";
    cartao.id = "cartao-" + i;
    cartao.onclick = function () {
      virarCartao(this.id);
    };
    mostrarFrente(cartao, i);
    elCartoes.appendChild(cartao);
  }
}

// Frente do cartão: só a pista
function mostrarFrente(cartao, i) {
  cartao.className = "cartao";
  cartao.innerHTML =
    '<div class="numero-cartao">#' + (i + 1) + '</div>' +
    '<p class="texto-cartao">' + palavras[i].pista + '</p>' +
    '<p class="texto-cartao">👆 clique para ver a resposta</p>';
}

// Verso do cartão: resposta e explicação
function mostrarVerso(cartao, i) {
  cartao.className = "cartao virado";
  cartao.innerHTML =
    '<div class="numero-cartao">#' + (i + 1) + '</div>' +
    '<div class="titulo-cartao">' + palavras[i].nome + '</div>' +
    '<p class="texto-cartao">' + palavras[i].explicacao + '</p>';
}

function virarCartao(id) {
  var cartao = document.getElementById(id);
  var i = Number(id.replace("cartao-", ""));

  if (cartao.className == "cartao") {
    mostrarVerso(cartao, i);
  } else {
    mostrarFrente(cartao, i);
  }
}

// ----- Abas -----
function irParaJogar() {
  telaJogar.style.display = "block";
  telaEstudar.style.display = "none";
  abaJogar.className = "ativa";
  abaEstudar.className = "";
}

function irParaEstudar() {
  telaJogar.style.display = "none";
  telaEstudar.style.display = "block";
  abaJogar.className = "";
  abaEstudar.className = "ativa";
}

// Ligando os botões
botaoConferir.onclick = conferir;
botaoProxima.onclick = proxima;
botaoReiniciar.onclick = reiniciar;
abaJogar.onclick = irParaJogar;
abaEstudar.onclick = irParaEstudar;

// Começa tudo
criarCartoes();
reiniciar();
