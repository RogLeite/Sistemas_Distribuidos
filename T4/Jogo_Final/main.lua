local macro_TESTING = true
-- aspas pra micaele: ""
local mqtt = require ("mqtt_library")

function change_Jogo(str)
  if Jogo == "Menu" then
    if just_started then
      just_started = false
      cutscenes.ativador = true
    elseif cutscenes.ativador then
      cutscenes.ativador = false
      BackGrounds.Ativada = true
    elseif BackGrounds.Ativada then
      BackGrounds.Ativada = false
      Escolha.Ativada = true
    elseif Escolha.Ativada then
      Escolha.Ativada = false
      InstrucoesAtivada = true
    elseif InstrucoesAtivada then
      InstrucoesAtivada = false
      if Escolha.Destaque == "Solo" then
        Jogo = "Jogo"
      elseif Escolha.Destaque == "Cooperativo" then
        Jogo = "Co-op"
      end
    end
  elseif Jogo == "Jogo" then
      if  Princesa.Capturada then
        Jogo = "Salve"
      end
  elseif Jogo == "Co-op" then
      if Princesa.Capturada then
        Jogo = "Salve Co-op"
      end
  elseif Jogo == "Game Over" then
      reset_Jogo()
      BackGrounds.Ativada = true
      Jogo = "Menu"
  elseif Jogo == "Salve" then
      if str == "Over" then
        Jogo = "Game Over"
      else
        Jogo = "Jogo"
      end
  elseif Jogo == "Salve Co-op" then
      if str == "Over" then
        Jogo = "Game Over"
      else
        Jogo = "Co-op"
      end
  end
end
function select_Background(key)
  if key == "up" then
    if BackGrounds.Destaque <= 2 then
      BackGrounds.Destaque = BackGrounds.Destaque + 3
    else
      BackGrounds.Destaque = BackGrounds.Destaque - 3
    end
  end
  if key == "down" then
    if BackGrounds.Destaque >= 3 then
      BackGrounds.Destaque = BackGrounds.Destaque - 3
    else
      BackGrounds.Destaque = BackGrounds.Destaque + 3
    end
  end
  if key == "left" then
    if BackGrounds.Destaque == 0 or BackGrounds.Destaque == 3 then
      BackGrounds.Destaque = BackGrounds.Destaque + 2
    else
      BackGrounds.Destaque = BackGrounds.Destaque - 1
    end
  end
  if key == "right" then
    if BackGrounds.Destaque == 2 or BackGrounds.Destaque == 5 then
      BackGrounds.Destaque = BackGrounds.Destaque - 2
    else
      BackGrounds.Destaque = BackGrounds.Destaque + 1
    end
  end
  if key == "return" then
    change_Jogo()
  end
end

function select_Modo(key)  
  if key == "up" or key == "down" then
    if Escolha.Destaque == "Cooperativo" then
      Escolha.Destaque = "Solo"
    elseif Escolha.Destaque == "Solo" then
      Escolha.Destaque = "Cooperativo"
    end
  end
  if key == "space" then
    change_Jogo()
  end
end


function update_Mario(dt)
  if Mario.anim_saida_down then   -- Movimento do Mario para Baixo
    Mario.tempo_saida = Mario.tempo_saida + dt --Conta o tempo
    if Mario.tempo_saida > 0.07 then
      Mario.animacao = 1 --Desativa animação
      Mario.anim_saida_down = false --Desativa a sinalização tecla pressionada
      Mario.anim_move = false --Controle do elseif
    elseif Mario.tempo_saida > 0.05 and Mario.anim_move == false then
      Mario.posy = Mario.posy + tam_linha --Movimentação
      Mario.Linha = Mario.Linha + 1 --Controle da linha que o mário se encontra
      Mario.anim_move = true --Controle do elseif
    elseif Mario.tempo_saida > 0.025 then
      Mario.animacao = 2 --Carrega a animação   
    end
  end
  if Mario.anim_saida_up == true then  -- Movimento do Mario para Cima
    Mario.tempo_saida = Mario.tempo_saida + dt --Conta o tempo
    if Mario.tempo_saida > 0.07 then
      Mario.animacao = 1 --Desativa animação
      Mario.anim_saida_up = false --Desativa a sinalização de tecla pressionada
      Mario.anim_move = false --Controle do elseif
    elseif Mario.tempo_saida > 0.05 and Mario.anim_move == false then
      Mario.posy = Mario.posy - tam_linha --Movimentação
      Mario.Linha = Mario.Linha - 1 --Controle da linha que o mário se encontra
      Mario.anim_move = true --Controle do elseif
    elseif Mario.tempo_saida > 0.025 then
      Mario.animacao = 2  --Carrega a animação       
    end
  end
end


function update_Luigi(dt)
  if Luigi.anim_saida_down == true then   -- Movimento do Luigi para Baixo
    Luigi.tempo_saida = Luigi.tempo_saida + dt --Conta o tempo
    if Luigi.tempo_saida > 0.07 then
      Luigi.animacao = 1 --Desativa animação
      Luigi.anim_saida_down = false --Desativa a sinalização tecla pressionada
      Luigi.anim_move = false --Controle do elseif
    elseif Luigi.tempo_saida > 0.05 and Luigi.anim_move == false then
      Luigi.posy = Luigi.posy + tam_linha --Movimentação
      Luigi.Linha = Luigi.Linha + 1 --Controle da linha que o Luigi se encontra
      Luigi.anim_move = true --Controle do elseif
    elseif Luigi.tempo_saida > 0.025 then
      Luigi.animacao = 2 --Carrega a animação   
    end
  end
  if Luigi.anim_saida_up == true then  -- Movimento do Luigi para Cima
    Luigi.tempo_saida = Luigi.tempo_saida + dt --Conta o tempo
    if Luigi.tempo_saida > 0.07 then
      Luigi.animacao = 1 --Desativa animação
      Luigi.anim_saida_up = false --Desativa a sinalização de tecla pressionada
      Luigi.anim_move = false --Controle do elseif
    elseif Luigi.tempo_saida > 0.05 and Luigi.anim_move == false then
      Luigi.posy = Luigi.posy - tam_linha --Movimentação
      Luigi.Linha = Luigi.Linha - 1 --Controle da linha que o Luigi se encontra
      Luigi.anim_move = true --Controle do elseif
    elseif Luigi.tempo_saida > 0.025 then
      Luigi.animacao = 2  --Carrega a animação       
    end
  end  
end


function move_Passaros(dt)
  for i = 0 , 10, 1 do   --Atualizar a posição do pássaro
    if inimigos[i].cores == 1 then
      inimigos[i].posicaox = inimigos[i].posicaox + window.w/8 * dt * Controle_Inimigos.Velocidade -- 100
    elseif inimigos[i].cores == 2 then
      inimigos[i].posicaox = inimigos[i].posicaox + 6 * window.w/40 * dt * Controle_Inimigos.Velocidade  -- 120
    elseif inimigos[i].cores == 3 then
      inimigos[i].posicaox = inimigos[i].posicaox + 7 * window.w/40 * dt * Controle_Inimigos.Velocidade  -- 140
    elseif inimigos[i].cores == 4 then
      inimigos[i].posicaox = inimigos[i].posicaox + window.w/5 * dt * Controle_Inimigos.Velocidade  -- 160
    elseif inimigos[i].cores == 5 then
      inimigos[i].posicaox = inimigos[i].posicaox + 9 * window.w/40 * dt * Controle_Inimigos.Velocidade  -- 180
    end
  end
  Controle_Inimigos.Velocidade = ((Pontuacao+1)^(1/4)) -- mudança da velocidade dos passaros
end



function spawn_Passaros(dt)
  --Controle de criação de inimigos
  Controle_Inimigos.tempo_aparicao = Controle_Inimigos.tempo_aparicao + dt
  if (Controle_Inimigos.tempo_aparicao > 1.5 and Jogo == "Jogo") or ( Controle_Inimigos.tempo_aparicao > 1 and Jogo == "Co-op") then
      local i = 0
      while (i < 10) do
        if inimigos[i].cores == 0 then
          inimigos[i].cores = math.random(1,Dificuldade.Nivel)
          inimigos[i].linha = math.random(0,3)
          inimigos[i].posicaox = 0
          i = 10
        end  
        i = i + 1 
        end
      Controle_Inimigos.tempo_aparicao = 0
    end
  end


function collision_Passaros(dt) 
  for i = 0, 10, 1 do --Colisão dos Passaros
    for j = 6, 0, -1 do
      if ChecarColisaoPassaro(inimigos[i].posicaox, tam_coluna, 3 * window.w/4 - (j+1) * tam_coluna, 2 * tam_coluna/5) and Matriz_Cano[inimigos[i].linha][j] == inimigos[i].cores and inimigos[i].cores ~= 0 then
        EfeitoColisao.Ativada = true
        EfeitoColisao.PosX = 3 * window.w/4 - (j+1) * tam_coluna - tam_coluna/2
        EfeitoColisao.PosY = inimigos[i].linha * tam_linha + window.h/4
        EfeitoColisao.Contador = 0
        Pontuacao = Pontuacao + inimigos[i].cores
        inimigos[i].cores = 0
        Moedas = Moedas + Matriz_Cano[inimigos[i].linha][j]
        Matriz_Cano[inimigos[i].linha][j] = 0
      elseif ChecarColisaoPassaro(inimigos[i].posicaox, tam_coluna, 3 * window.w/4 - (j+1) * tam_coluna, 2 * tam_coluna/5) and Matriz_Cano[inimigos[i].linha][j] ~= inimigos[i].cores and Matriz_Cano[inimigos[i].linha][j] ~= 0 then
        EfeitoColisao.Ativada = true
        EfeitoColisao.PosX = 3 * window.w/4 - (j+1) * tam_coluna - tam_coluna/2
        EfeitoColisao.PosY = inimigos[i].linha * tam_linha + window.h/4
        EfeitoColisao.Contador = 0
        Moedas = Moedas + Matriz_Cano[inimigos[i].linha][j]
        Matriz_Cano[inimigos[i].linha][j] = 0
      end
    end
    if inimigos[i].posicaox >= Mario.posx - 2 * tam_coluna/5 then -- Controle da mudança de jogo
      Princesa.Cor = inimigos[i].cores
      Princesa.Linha = inimigos[i].linha
      Princesa.PosY = window.h/4 + tam_linha * Princesa.Linha
      BolaFogo.PosY = Mario.posy
      BolaFogo.Diferenca = (Princesa.PosY + (Princesa.Linha * tam_linha)) - BolaFogo.PosY
      Controle_Inimigos.tempo_aparicao = 0
      for t = 0, 10, 1 do
        inimigos[t].cores = 0
        inimigos[t].posicaox = -tam_coluna
      end
      for t = 0, 3, 1 do
        for g = 0, 6, 1 do
          Matriz_Cano[t][g] = 0
        end
      end
      Princesa.Capturada = true
      change_Jogo()
    end
    if inimigos[i].cores == 0 then -- Remove os pássaros inexistentes do caminho
      inimigos[i].posicaox = - tam_coluna
    end
  end
end



function check_GameOver()
  if Princesa.PosX <= 0 then
    BolaFogo.Tamanho = 0
    change_Jogo("Over")
  end  
end




function move_Princesa(dt)
  Princesa.PosX = Princesa.PosX - window.w/8 * dt  
end


function move_Bola(dt)
  BolaFogo.PosX = BolaFogo.PosX - (1500 * dt)
  BolaFogo.PosY = BolaFogo.PosY + (Princesa.PosY-BolaFogo.PosY)*20*dt
  if BolaFogo.PosX <= Princesa.PosX + 75 then
    BolaFogo.Tamanho = 0
    BolaFogo.PosX = Mario.posx
    Pontuacao = Pontuacao + Princesa.Cor
    Princesa.Cor = 0
    Princesa.PosX = 3 * window.w/4
    Princesa.Nivel = Princesa.Nivel + 1
    Princesa.Contador = 0
    Moedas = 50
    change_Jogo()
  end
end





function update_Cutscene(dt)
  if cutscenes.bandodeflappy.posicaox[1] > window.w then
    end_Cutscene()
  end
  cutscenes.contador = cutscenes.contador + dt
  if cutscenes.bowser.posicaox >= window.w/2 then
     cutscenes.bowser.posicaox = cutscenes.bowser.posicaox  - 75 * dt --15*dt
      if cutscenes.contador >= 0.3 then
        if cutscenes.bowser.anim == 2 then
          cutscenes.bowser.anim = 3
          cutscenes.contador  = 0
        elseif cutscenes.bowser.anim == 3 then
          cutscenes.bowser.anim = 2
          cutscenes.contador  = 0
        end
      end
  else --Nesse momento bowser já colocou cano 
    if cutscenes.flappybird.posicaox < cutscenes.bowser.posicaox - 165 then --Flappybird se move
      cutscenes.flappybird.posicaox = cutscenes.flappybird.posicaox + 90 * dt
      cutscenes.contador  = 0
    elseif cutscenes.flappybird.posicaox >= cutscenes.bowser.posicaox - 165  and cutscenes.flappybird.posicaoy <= 380 then
      cutscenes.flappybird.posicaoy = cutscenes.flappybird.posicaoy  + 40 * dt
    elseif cutscenes.flappybird.posicaoy >= 380  and cutscenes.contador >= 1.5 then
      for i = 1 ,20 ,1 do 
        cutscenes.bandodeflappy.posicaox[i] = cutscenes.bandodeflappy.posicaox[i] + (30+i) * (20 * dt)
      end
    end
  end
end


function update_Nivel()
  if Pontuacao < 15 then -- Controle da Dificuldade em função da Pontuação
    Dificuldade.Nivel = 1
  elseif Pontuacao >= 15 and Pontuacao < 40 then
    Dificuldade.Nivel = 2
  elseif Pontuacao >= 40 and Pontuacao < 80 then
    Dificuldade.Nivel = 3
  elseif Pontuacao >= 80 and Pontuacao < 140 then
    Dificuldade.Nivel = 4
  elseif Pontuacao >= 140 then
    Dificuldade.Nivel = 5
  end
end


function update_Efeito(dt)
  if EfeitoColisao.Ativada == true then
    EfeitoColisao.Contador = EfeitoColisao.Contador + dt
    if EfeitoColisao.Contador >= 0.5 then
      delete_Efeito()
    end
  end  
end

function delete_Efeito()
  EfeitoColisao.Ativada = false
  EfeitoColisao.Contador = 0
end

function reset_Jogo()
  for i = 0, 3, 1 do
    for j = 0, 6, 1 do
      Matriz_Cano[i][j] = 0
    end
  end
  for i = 0, 10, 1 do
    inimigos[i].cores = 0
  end
  Pontuacao = 0
  Mario.Cano_Selecionado = 1
  Luigi.Cano_Selecionado = 1
  Mario.posy = window.h/4
  Luigi.posy = window.h/4
  Mario.Linha = 0
  Luigi.Linha = 0
  Princesa.Nivel = 1
  Princesa.Contador = 0
  Princesa.PosX = 3 * window.w/4
  Princesa.Cor = 0
  Moedas = 50
  BackGrounds.Destaque = 0
end






function cresce_Bola()
  if Jogo == "Salve" and Princesa.Contador < 10 * Princesa.Nivel then
    Princesa.Contador = Princesa.Contador + 1
    BolaFogo.Tamanho = (Princesa.Contador/(10*Princesa.Nivel))
  elseif Jogo == "Salve Co-op" and Princesa.Contador < 20 * Princesa.Nivel then
    Princesa.Contador = Princesa.Contador + 1
    BolaFogo.Tamanho = (Princesa.Contador/(20*Princesa.Nivel))
  end
end

function save_Mario(key)
  if key == "left" then -- Cresce a Bola de Fogo
    cresce_Bola()
  end
end

function save_Luigi(key)
  if key == "a" then
    cresce_Bola()
  end
end

function Por_Cano_keypressed(Cano_Selecionado, Linhapers) -- Armazena Cano_Selecionado na Matriz Cano
  for Coluna = 6, 1, -1 do -- Percorre a Matriz_Cano ajustando a posição deles.
    Matriz_Cano[Linhapers][Coluna] = Matriz_Cano[Linhapers][Coluna - 1]
  end
  Matriz_Cano[Linhapers][0] = Cano_Selecionado -- Põe o Cano_Selecionado
end


function controle_Luigi(key)
  if key == "g" and Dificuldade.Nivel >= 1 then -- Seleção de Canos Luigi
    Luigi.Cano_Selecionado = 1 -- Verde
  elseif key == "h" and Dificuldade.Nivel >= 2 then
    Luigi.Cano_Selecionado = 2 -- Amarelo
  elseif key == "j" and Dificuldade.Nivel >= 3 then
    Luigi.Cano_Selecionado = 3 -- Azul
  elseif key == "t" and Dificuldade.Nivel >= 4 then
    Luigi.Cano_Selecionado = 4 -- Vermelho
  elseif key == "y" and Dificuldade.Nivel >= 5 then
    Luigi.Cano_Selecionado = 5 -- Preto
  end
  if key == "a" and Moedas >= Luigi.Cano_Selecionado and Matriz_Cano[Luigi.Linha][6] == 0 then  -- Põe o Cano na Matriz-- Luigi
    Por_Cano_keypressed(Luigi.Cano_Selecionado, Luigi.Linha)
    Moedas = Moedas - Luigi.Cano_Selecionado -- Gasta a Moeda
  end
  if key == "s" and not(Luigi.posy == (23*window.h/32)) then  -- Movimento Luigi -- Limite Inferior
    Luigi.anim_saida_down = true --Caso o jogador tenha pressionado
    Luigi.tempo_saida = 0 --Inicializa o tempo de aniamação
  elseif key == "w" and not(Luigi.posy == window.h/4) then -- Limite Superior
    Luigi.anim_saida_up = true --Caso o jogador tenha pressionado
    Luigi.tempo_saida = 0 --Inicializa o tempo de animação
  end
end

function controle_Mario(key)
  if key == "kp1" and Dificuldade.Nivel >= 1 then -- Seleção de Canos, com bloqueio das cores ainda não liberadas
    Mario.Cano_Selecionado = 1 -- Verde
  elseif key == "kp2" and Dificuldade.Nivel >= 2 then
    Mario.Cano_Selecionado = 2 -- Amarelo
  elseif key == "kp3" and Dificuldade.Nivel >= 3 then
    Mario.Cano_Selecionado = 3 -- Azul
  elseif key == "kp4" and Dificuldade.Nivel >= 4 then
    Mario.Cano_Selecionado = 4 -- Vermelho
  elseif key == "kp5" and Dificuldade.Nivel >= 5 then
    Mario.Cano_Selecionado = 5 -- Preto
  end
  if key == "left" and Moedas >= Mario.Cano_Selecionado and Matriz_Cano[Mario.Linha][6] == 0 then  -- Põe o Cano na Matriz-- Mario
    Por_Cano_keypressed(Mario.Cano_Selecionado, Mario.Linha)
    Moedas = Moedas - Mario.Cano_Selecionado -- Gasta a Moeda
  end
  if key == "down" and not(Mario.posy == (23*window.h/32)) then  --Movimento do Mario -- Limite Inferior
      Mario.anim_saida_down = true --Caso o jogador tenha pressionado
      Mario.tempo_saida = 0 --Inicializa o tempo de aniamação
  elseif key == "up" and not(Mario.posy == window.h/4) then -- Limite Superior
      Mario.anim_saida_up = true --Caso o jogador tenha pressionado
      Mario.tempo_saida = 0 --Inicializa o tempo de animação
  end
end



function ChecarColisaoPassaro(XP, WP, XC, X) --x do Passaro, Largura do Passaro, x do Cano, Extra
  return XC < XP + WP - X
  end

function love.load()
  just_started = true
  window = {}
  window.h = love.graphics.getHeight()
  window.w = love.graphics.getWidth()
  love.window.setTitle("Canos vs. FlappyBird")
  myfont = love.graphics.newFont("GretoonHighlight.ttf", 20)
  love.graphics.setFont(myfont)
  Jogo = "Menu" -- 0-Menu 1-Jogo 2-Salve 3-Game Over 4-Co-op 5-Salve Co-op
  Moedas = 50 -- Máximo de Moedas
  inimigos = {} -- Vetor de tabelas dos inimigos
  Matriz_Cano = {} -- Armazena a Cor do cano em sua Posição
  Pontuacao = 0
  tam_linha = 5*window.h/32 -- Altura da linha em função da tela
  tam_coluna = 5*window.w/48 -- Largura da Coluna em função da tela
  Mario = { -- Biblioteca do Jogador 1
    Cano_Selecionado = 1, -- 1-Verde 2-Amarelo 3-Azul 4-Vermelho 5-Preto
    posx = 3*window.w/4,
    posy = window.h/4,
    Linha = 0, -- Armazena em que Linha o Jogador está
    animacao = 1, --Imagem que será apresentada
    anim_saida_down = false, --Controla o pressionameto do teclado(movimentação) 
    anim_saida_up = false,--Controla o pressionameto do teclado(movimentação) 
    anim_move = false, --Controla a liberação do personagem para se movimentar
    tempo_saida = 0  --Contador de tempo de movimentação do personagem
  }
  Luigi = { -- Biblioteca do Jogador 2
    Cano_Selecionado = 1, -- 1-Verde 2-Amarelo 3-Azul 4-Vermelho 5-Preto
    posx = 3*window.w/4 + tam_coluna,
    posy = window.h/4,
    Linha = 0, -- Armazena em que Linha o Jogador está
    animacao = 1, --Imagem que será apresentada
    anim_saida_down = false, --Controla o pressionameto do teclado(movimentação) 
    anim_saida_up = false,--Controla o pressionameto do teclado(movimentação) 
    anim_move = false, --Controla a liberação do personagem para se movimentar
    tempo_saida = 0  --Contador de tempo de movimentação do personagem
  }
  Princesa = {
    Nivel = 1,--Armazena quantas vezes ela já foi resgatada
    PosX = 3*window.w/4,
    PosY = window.h/4,
    Cor = 0,--Armazena a cor que o flappybird terá
    Contador = 0, -- Armazena o clique de teclas para derrotar o pássaro
    Capturada = false
  }
  Controle_Inimigos = {
    Velocidade = 1,-- Cresce em função da pontuação
    tempo_aparicao = 0 --Tempo desde a ultima aparição de um passaro
  }
  Dificuldade = {
    Nivel = 1,
  }
  BolaFogo = {
    Rotacao = 0,
    Tamanho = 0,
    PosX = Mario.posx,
    PosY = 0,
    Diferenca = 0 -- Diferença entre o Y da Bola e da Princesa
  }
  EfeitoColisao = {
    Ativada = false,
    PosX = 0,
    PosY = 0, 
    TamanhoX = tam_coluna/430,
    TamanhoY = tam_linha/357,
    Contador = 0
  }
  cutscenes = {
    contador = 0, --Medidor de tempo
    ativador = false, --ativa cutscenes
    bowser = {
      anim = 2, --Guarda informação sobre a imagem a ser impresa do bowser
      posicaox = window.w,
      posicaoy = 300
    },
    flappybird = {
      posicaox = 0 ,
      posicaoy = 300,
      contador = 0,
    },
    bandodeflappy = {
      posicaox = {},
      posicaoy = {}
      }
  }
  Escolha = { -- Armazena informações da tela de Modo de Jogo
    Ativada = false,
    Destaque = "Solo" -- Solo ou Cooperativo
  }
  BackGrounds = {
    Ativada = false,
    Destaque = 0, -- 0-Lava, 1-Neve, 2-Mario, 3-Nuvem, 4-Floresta, 5-Deserto
  }
  InstrucoesAtivada = false
   for i = 1 , 20 , 1 do -- Inicializa o Bando de Flappy da Cutscene
     cutscenes.bandodeflappy.posicaox[i] = (-15 + i)*10 - 120
     cutscenes.bandodeflappy.posicaoy[i] = math.random( 50, 250)
   end
  bowser01 = love.graphics.newImage("Browser01.png")
  bowser02 = love.graphics.newImage("Browser02.png")
  bowser03 = love.graphics.newImage("Browser03.png")
  -- 800x600
  Instrucoes = love.graphics.newImage("Instrucoes.png")
  Cenario = love.graphics.newImage("Cenario.png")
  SelecaoLava = love.graphics.newImage("SelecaoLava.png")
  SelecaoNeve = love.graphics.newImage("SelecaoNeve.png")
  SelecaoMario = love.graphics.newImage("SelecaoMario.png")
  SelecaoNuvem = love.graphics.newImage("SelecaoNuvem.png")
  SelecaoFloresta = love.graphics.newImage("SelecaoFloresta.png")
  SelecaoDeserto = love.graphics.newImage("SelecaoDeserto.png")
  Seletor = love.graphics.newImage("Seletor.png")
  MododeJogo = love.graphics.newImage("Modo de jogo.png")
  Cutscene = love.graphics.newImage("Cutscene.png")
  Menu = love.graphics.newImage("Menu.png")
  Lava = love.graphics.newImage("Lava.png")
  Reino = love.graphics.newImage("Reino.png")
  Floresta = love.graphics.newImage("Floresta.png")
  Deserto = love.graphics.newImage("Deserto.png")
  Gelo = love.graphics.newImage("Gelo.png")
  Nuvem = love.graphics.newImage("Nuvem.png")
  Interface = love.graphics.newImage("Interface.png")
  -- 430x357
  Bam = love.graphics.newImage("bam.png")
  --Personagens 250x250
  flappyverde = love.graphics.newImage("Verde - Flappy Bird.png")
  flappyamarelo = love.graphics.newImage("Laranja - Flappy Bird.png")
  flappyazul = love.graphics.newImage("Azul Escuro - Flappy Bird.png")
  flappyvermelho = love.graphics.newImage("Vermelho - Flappy Bird.png")
  flappypreto = love.graphics.newImage("Preto - Flappy Bird.png")
  flappyverdemorto = love.graphics.newImage("flappymorto.png")
  --128x128
  BolaDeFogo = love.graphics.newImage("boladefogo.png")
  Cano_Verde = love.graphics.newImage("Cano_Verde.png")
  Cano_Amarelo = love.graphics.newImage("Cano_Laranja.png")
  Cano_Azul = love.graphics.newImage("Cano_Azul.png")
  Cano_Vermelho = love.graphics.newImage("Cano_Vermelho.png")
  Cano_Preto = love.graphics.newImage("Cano_Preto.png")
    -- Cano Selecionado
    MarioCanoVerde = love.graphics.newImage("MarioCanoVerde.png")
    MarioCanoAmarelo = love.graphics.newImage("MarioCanoAmarelo.png")
    MarioCanoAzul = love.graphics.newImage("MarioCanoAzul.png")
    MarioCanoVermelho = love.graphics.newImage("MarioCanoVermelho.png")
    MarioCanoPreto = love.graphics.newImage("MarioCanoPreto.png")
    LuigiCanoVerde = love.graphics.newImage("LuigiCanoVerde.png")
    LuigiCanoAmarelo = love.graphics.newImage("LuigiCanoAmarelo.png")
    LuigiCanoAzul = love.graphics.newImage("LuigiCanoAzul.png")
    LuigiCanoVermelho = love.graphics.newImage("LuigiCanoVermelho.png")
    LuigiCanoPreto = love.graphics.newImage("LuigiCanoPreto.png")
  --32x32
  mario_normal = love.graphics.newImage("Mario01.png")
  mario_movimento = love.graphics.newImage("Mario02.png")
  luigi_normal = love.graphics.newImage("Luigi01.png")
  luigi_movimento = love.graphics.newImage("Luigi02.png")
  -- Princesa
  PrincesaVerde = love.graphics.newImage("princesaverde.png")
  PrincesaAmarelo = love.graphics.newImage("princesaamarelo.png")
  PrincesaAzul = love.graphics.newImage("princesaazul.png")
  PrincesaVermelho = love.graphics.newImage("princesavermelho.png")
  PrincesaPreto = love.graphics.newImage("princesapreto.png")
  for i = 0, 10, 1 do -- Inicializa inimigos[i]
    inimigos[i] = {
      linha = 0,
      posicaox = 0,
      cores = 0
    }
  end
  for i= 0, 3, 1 do  -- Inicializa a Matriz_Cano toda como vazia
    Matriz_Cano[i] = {}
    for j=0, 6, 1 do
      Matriz_Cano[i][j] = 0 
    end
  end
end

function love.keypressed(key)
  
  if Jogo == "Jogo" then -- Jogo
    controle_Mario(key)
  elseif Jogo == "Co-op" then -- Jogo Cooperativo
    controle_Mario(key)
    controle_Luigi(key)
  elseif Jogo == "Salve" then -- Salve a Princesa
    save_Mario(key)
  elseif Jogo == "Salve Co-op" then
    save_Mario(key)
    save_Luigi(key)
  elseif Jogo == "Game Over" then -- Game Over
    if key == "return" then -- Reinicia o Jogo
      change_Jogo()
    end
  elseif Jogo == "Menu" then -- Menu
    if just_started then
      if key == "return" then
        change_Jogo()
      end
    end
    if cutscenes.ativador then
      if key == "kpenter" or key == "p" then
        change_Jogo()
      end
    end
    if BackGrounds.Ativada then
      select_Background(key)
    end
    if Escolha.Ativada then
      select_Modo(key)
    end
    if InstrucoesAtivada then
      if key == "return" then
        change_Jogo()
      end
    end
  end
  if key == "escape" then -- Saída do Programa
    love.event.quit()
  end
end
function love.update(dt)
  
  if Jogo == "Jogo" then-- Jogo
    update_Mario(dt)
    move_Passaros(dt)
    spawn_Passaros(dt)
    collision_Passaros(dt)
    update_Nivel()
    update_Efeito(dt)
  elseif Jogo == "Co-op" then
    update_Mario(dt)
    update_Luigi(dt)
    move_Passaros(dt)
    spawn_Passaros(dt)
    collision_Passaros(dt)  
    update_Nivel()
    update_Efeito(dt)
  elseif Jogo == "Salve" then
    delete_Efeito()
    check_GameOver()
    if Princesa.Contador < (10 * Princesa.Nivel) then --Princesa n foi resgatada
      move_Princesa(dt)
    elseif Princesa.Contador >= (10 * Princesa.Nivel) then --Princesa foi resgatada
      move_Bola(dt)
    end
  elseif Jogo == "Salve Co-op" then
    delete_Efeito()
    check_GameOver()
    if Princesa.Contador < (20 * Princesa.Nivel) then
      move_Princesa(dt)
    elseif Princesa.Contador >= (20 * Princesa.Nivel) then
      move_Bola(dt)
    end
  elseif Jogo == "Menu" then -- Menu
    delete_Efeito()
    if cutscenes.ativador == true then --cutscenes
      update_Cutscene(dt)
    end
  end
  
end
function love.draw()
  if Jogo == "Jogo" or Jogo == "Salve" or Jogo == "Co-op" or Jogo == "Salve Co-op" then
    love.graphics.setBackgroundColor(160,194,250)
    if BackGrounds.Destaque == 0 then
      love.graphics.draw(Lava, 0, 0)
    elseif BackGrounds.Destaque == 1 then
      love.graphics.draw(Gelo, 0, 0)
    elseif BackGrounds.Destaque == 2 then
      love.graphics.draw(Reino, 0, 0)
    elseif BackGrounds.Destaque == 3 then
      love.graphics.draw(Nuvem, 0, 0)
    elseif BackGrounds.Destaque == 4 then
      love.graphics.draw(Floresta, 0, 0)
    elseif BackGrounds.Destaque == 5 then
      love.graphics.draw(Deserto, 0, 0)
    end
    love.graphics.draw(Interface, 0, 0)
    if Mario.animacao == 1 then  -- Animação do Mario normal
      love.graphics.draw(mario_normal,
        Mario.posx,
        Mario.posy,
        0,
        5*window.w/1536,
        15*window.h/4096
        )
    elseif Mario.animacao == 2 then -- Animação do Mario andando
      love.graphics.draw(mario_movimento,
        Mario.posx,
        Mario.posy,
        0,
        5*window.w/1536,
        15*window.h/4096
        )
    end
    --Seleção de canos
    love.graphics.draw(Cano_Verde,
      window.w - tam_coluna,
      window.h *8 /9,
      0,
      tam_coluna/128,
      tam_linha/196)
    love.graphics.draw(Cano_Amarelo,
      window.w - 2 * tam_coluna,
      window.h *8/9,
      0,
      tam_coluna/128,
      tam_linha/196)
    love.graphics.draw(Cano_Azul,
      window.w  - 3 * tam_coluna,
      window.h *8/9,
      0,
      tam_coluna/128,
      tam_linha/196)
    love.graphics.draw(Cano_Vermelho,
      window.w - 4 * tam_coluna,
      window.h *8/9,
      0,
      tam_coluna/128,
      tam_linha/196)
    love.graphics.draw(Cano_Preto,
      window.w - 5 * tam_coluna,
      window.h *8/9,
      0,
      tam_coluna/128,
      tam_linha/196)
    if Mario.Cano_Selecionado == 1 then
      love.graphics.draw(MarioCanoVerde,
      window.w - tam_coluna,
      window.h *8 /9,
      0,
      tam_coluna/128,
      tam_linha/196)
    elseif Mario.Cano_Selecionado == 2 then
      love.graphics.draw(MarioCanoAmarelo,
      window.w - 2 * tam_coluna,
      window.h *8/9,
      0,
      tam_coluna/128,
      tam_linha/196)
    elseif Mario.Cano_Selecionado == 3 then
      love.graphics.draw(MarioCanoAzul,
      window.w  - 3 * tam_coluna,
      window.h *8/9,
      0,
      tam_coluna/128,
      tam_linha/196)
    elseif Mario.Cano_Selecionado == 4 then
      love.graphics.draw(MarioCanoVermelho,
      window.w - 4 * tam_coluna,
      window.h *8/9,
      0,
      tam_coluna/128,
      tam_linha/196)
    elseif Mario.Cano_Selecionado == 5 then
      love.graphics.draw(MarioCanoPreto,
      window.w - 5 * tam_coluna,
      window.h *8/9,
      0,
      tam_coluna/128,
      tam_linha/196)
    end
    if Jogo == "Co-op" or Jogo == "Salve Co-op" then
      if Luigi.animacao == 1 then  -- Animação do Luigi normal
        love.graphics.draw(luigi_normal,
          Luigi.posx,
          Luigi.posy,
          0,
          5*window.w/1536,
          15*window.h/4096
          )
      elseif Luigi.animacao == 2 then -- Animação do Luigi andando
        love.graphics.draw(luigi_movimento,
          Luigi.posx,
          Luigi.posy,
          0,
          5*window.w/1536,
          15*window.h/4096
          )
      end
      love.graphics.draw(Cano_Verde,
        window.w/2 - tam_coluna,
        window.h *8 /9,
        0,
        tam_coluna/128,
        tam_linha/196)
      love.graphics.draw(Cano_Amarelo,
        window.w/2 - 2 * tam_coluna,
        window.h *8/9,
        0,
        tam_coluna/128,
        tam_linha/196)
      love.graphics.draw(Cano_Azul,
        window.w/2  - 3 * tam_coluna,
        window.h *8/9,
        0,
        tam_coluna/128,
        tam_linha/196)
      love.graphics.draw(Cano_Vermelho,
        window.w/2 - 4 * tam_coluna,
        window.h *8/9,
        0,
        tam_coluna/128,
        tam_linha/196)
      love.graphics.draw(Cano_Preto,
        window.w/2 - 5 * tam_coluna,
        window.h *8/9,
        0,
        tam_coluna/128,
        tam_linha/196)
      if Luigi.Cano_Selecionado == 1 then
        love.graphics.draw(LuigiCanoVerde,
        window.w/2 - tam_coluna,
        window.h *8 /9,
        0,
        tam_coluna/128,
        tam_linha/196)
      elseif Luigi.Cano_Selecionado == 2 then
        love.graphics.draw(LuigiCanoAmarelo,
        window.w/2 - 2 * tam_coluna,
        window.h *8/9,
        0,
        tam_coluna/128,
        tam_linha/196)
      elseif Luigi.Cano_Selecionado == 3 then
        love.graphics.draw(LuigiCanoAzul,
        window.w/2  - 3 * tam_coluna,
        window.h *8/9,
        0,
        tam_coluna/128,
        tam_linha/196)
      elseif Luigi.Cano_Selecionado == 4 then
        love.graphics.draw(LuigiCanoVermelho,
        window.w/2 - 4 * tam_coluna,
        window.h *8/9,
        0,
        tam_coluna/128,
        tam_linha/196)
      elseif Luigi.Cano_Selecionado == 5 then
        love.graphics.draw(LuigiCanoPreto,
        window.w/2 - 5 * tam_coluna,
        window.h *8/9,
        0,
        tam_coluna/128,
        tam_linha/196)
      end
    end
    for i = 0, 3, 1 do  -- Desenhar a Matriz_Cano
      for j = 0, 6, 1 do
        if Matriz_Cano[i][j] == 1 then --Canos verdes
          love.graphics.draw(Cano_Verde,
            3 * window.w/4 - (j+1) * tam_coluna,
            window.h/4 + i * tam_linha,
            0,
            tam_coluna/128,
            tam_linha/128
            )
        elseif Matriz_Cano[i][j] == 2 then --Canos amarelos
          love.graphics.draw(Cano_Amarelo,
            3 * window.w/4 - (j+1) * tam_coluna,
            window.h/4 + i * tam_linha,
            0,
            tam_coluna/128,
            tam_linha/128)
        elseif Matriz_Cano[i][j] == 3 then --Canos azuis
          love.graphics.draw(Cano_Azul,
            3 * window.w/4 - (j+1) * tam_coluna,
            window.h/4 + i * tam_linha,
            0,
            tam_coluna/128,
            tam_linha/128
            )
        elseif Matriz_Cano[i][j] == 4 then --Canos vermelhos
          love.graphics.draw(Cano_Vermelho,
            3 * window.w/4 - (j+1) * tam_coluna,
            window.h/4 + i * tam_linha,
            0,
            tam_coluna/128,
            tam_linha/128
            )
        elseif Matriz_Cano[i][j] == 5 then --Canos pretos
          love.graphics.draw(Cano_Preto,
            3 * window.w/4 - (j+1) * tam_coluna,
            window.h/4 + i * tam_linha,
            0,
            tam_coluna/128,
            tam_linha/128
            )
        end
      end
    end
    for i = 0, 10, 1 do 
      if inimigos[i].cores == 1 then 
        love.graphics.draw(flappyverde,
          inimigos[i].posicaox,
          window.h/4 + inimigos[i].linha * tam_linha,
          0,
          tam_coluna/250,
          tam_linha/250
          )
      elseif inimigos[i].cores == 2 then 
        love.graphics.draw(flappyamarelo,
          inimigos[i].posicaox,
          window.h/4 + inimigos[i].linha * tam_linha,
          0,
          tam_coluna/250,
          tam_linha/250
          )
      elseif inimigos[i].cores == 3 then 
        love.graphics.draw(flappyazul,
          inimigos[i].posicaox,
          window.h/4 + inimigos[i].linha * tam_linha,
          0,
          tam_coluna/250,
          tam_linha/250
          )
      elseif inimigos[i].cores == 4 then 
        love.graphics.draw(flappyvermelho,
          inimigos[i].posicaox,
          window.h/4 + inimigos[i].linha * tam_linha,
          0,
          tam_coluna/250,
          tam_linha/250
          )  
      elseif inimigos[i].cores == 5 then 
        love.graphics.draw(flappypreto,
          inimigos[i].posicaox,
          window.h/4 + inimigos[i].linha * tam_linha,
          0,
          tam_coluna/250,
          tam_linha/250
          ) 
      end
    end
    if EfeitoColisao.Ativada == true then
      love.graphics.draw(Bam, EfeitoColisao.PosX, EfeitoColisao.PosY, 0, EfeitoColisao.TamanhoX, EfeitoColisao.TamanhoY)
    end
    --Imprime a princesa no modo salve a princesa
    if Princesa.Cor == 1 then
      love.graphics.draw(PrincesaVerde,
        Princesa.PosX,
        Princesa.PosY,
        0,
        tam_coluna/592,
        tam_linha/750
        )
    elseif Princesa.Cor == 2 then
      love.graphics.draw(PrincesaAmarelo,
        Princesa.PosX,
        Princesa.PosY,
        0,
        tam_coluna/592,
        tam_linha/750
        )
    elseif Princesa.Cor == 3 then
      love.graphics.draw(PrincesaAzul,
        Princesa.PosX,
        Princesa.PosY,
        0,
        tam_coluna/592,
        tam_linha/750
        )
    elseif Princesa.Cor == 4 then
      love.graphics.draw(PrincesaVermelho,
        Princesa.PosX,
        Princesa.PosY,
        0,
        tam_coluna/592,
        tam_linha/750
        )
    elseif Princesa.Cor == 5 then
      love.graphics.draw(PrincesaPreto,
        Princesa.PosX,
        Princesa.PosY,
        0,
        tam_coluna/592,
        tam_linha/750
        )
    end
    --Interface
    love.graphics.print(Moedas, 140, 35)
    love.graphics.print(Pontuacao, 350, 35)
    love.graphics.draw(BolaDeFogo, BolaFogo.PosX, BolaFogo.PosY, 0, BolaFogo.Tamanho, BolaFogo.Tamanho, (128 * BolaFogo.Tamanho)/2, (128 * BolaFogo.Tamanho)/2)
  elseif Jogo == "Game Over" then
    love.graphics.setBackgroundColor( 0, 0, 0)
    love.graphics.print("Pontuação", 350, 270)
    love.graphics.print(Pontuacao, 400, 300)
  elseif Jogo == "Menu" then
    if cutscenes.ativador == false and Escolha.Ativada == false and BackGrounds.Ativada == false and InstrucoesAtivada == false then
      love.graphics.draw(Menu, 0, 0)
    elseif cutscenes.ativador == true then --Usuário pressionou enter
      love.graphics.draw(Cutscene, 0, 0)
      if cutscenes.bowser.posicaox <= window.w/2 then
        --Após o bowser parar de se mover
        if cutscenes.contador<=0.33 then
          love.graphics.draw(bowser01,cutscenes.bowser.posicaox,cutscenes.bowser.posicaoy)--Fixa a imagem do bowser 
        end
      love.graphics.draw(Cano_Verde, cutscenes.bowser.posicaox - 138,cutscenes.bowser.posicaoy)--Coloca o cano
        if cutscenes.flappybird.posicaox < cutscenes.bowser.posicaox - 165 then
          love.graphics.draw(flappyverde, cutscenes.flappybird.posicaox, cutscenes.flappybird.posicaoy, 0, 1/4, 1/4)
        else
          love.graphics.draw(flappyverdemorto, cutscenes.flappybird.posicaox + 50, cutscenes.flappybird.posicaoy + 50, -3, 1/4, 1/4)
          if cutscenes.contador >0.4 then
            for i = 1, 20 , 1 do
              love.graphics.draw(flappyverde,
                cutscenes.bandodeflappy.posicaox[i],
                cutscenes.bandodeflappy.posicaoy[i],
                0,
                1/4,
                1/4)
            end
          end
        end
      else
        --Controle da animação do bowser enquanto o bowser caminha na tela
        if cutscenes.bowser.anim == 1 and not(cutscenes.bowser.posicaox >= window.w/2) then
          love.graphics.draw(bowser01, cutscenes.bowser.posicaox, cutscenes.bowser.posicaoy)
        elseif cutscenes.bowser.anim == 2 then
          love.graphics.draw(bowser02, cutscenes.bowser.posicaox, cutscenes.bowser.posicaoy)
        elseif cutscenes.bowser.anim == 3 then
          love.graphics.draw(bowser03, cutscenes.bowser.posicaox, cutscenes.bowser.posicaoy)
        end
      end
    elseif Escolha.Ativada == true then
      love.graphics.draw(MododeJogo, 0, 0)
      love.graphics.print("Pressione Espaço", 200, 500)
      if Escolha.Destaque == "Solo" then
        love.graphics.draw(Seletor, 0, 0)
      elseif Escolha.Destaque == "Cooperativo" then
        love.graphics.draw(Seletor, 0, 70)
      end
    elseif BackGrounds.Ativada == true then
      love.graphics.draw(Cenario, 0, 0)
      if BackGrounds.Destaque == 0 then
        love.graphics.draw(SelecaoLava, 0, 0)
      elseif BackGrounds.Destaque == 1 then
        love.graphics.draw(SelecaoNeve, 0, 0)
      elseif BackGrounds.Destaque == 2 then
        love.graphics.draw(SelecaoMario, 0, 0)
      elseif BackGrounds.Destaque == 3 then
        love.graphics.draw(SelecaoNuvem, 0, 0)
      elseif BackGrounds.Destaque == 4 then
        love.graphics.draw(SelecaoFloresta, 0, 0)
      elseif BackGrounds.Destaque == 5 then
        love.graphics.draw(SelecaoDeserto, 0, 0)
      end
    elseif InstrucoesAtivada == true then
      love.graphics.draw(Instrucoes, 0, 0)
      love.graphics.print("Pressione Enter", 40, 530)
      love.graphics.print("para Continuar", 40, 560)
    end
  end
end