--[[
este é um pequeno desafio que fiz para testar a linguagem Lua, tal que nunca tive contato antes


O desafio foi criar um sistema de cadastro e consulta de clientes simples


Basicamente, o sistema precisa ter essas funcionalidades: (criei essa lista antes de começar o código, usei como base para a criação)
1. Cadastrar clientes, contendo: Nome, Idade, E-mail
2. Listar todos os clientes cadastrados
3. Buscar um cliente pelo nome


Além da lua nativa, estou utilizando também a biblioteca dkjson (Copyright (C) 2010-2014 David Heiko Kolf)
Link:
https://github.com/LuaDist/dkjson/blob/master/dkjson.lua

Essa biblioteca é extremamente útil e basicamente ela permite codificar e decodificar dados no formato JSON
vou utilizar um arquivo JSON para guardar os clientes cadastrados
]]


-- criando uma tabela de registros para manter os clientes
local clientes = {}

-- para o arquivo json
local json = require("dkjson")


-- introudção ao usuário
print("Bem vindo ao sistema de cadastro e consultas e clientes em lua!\nO que deseja fazer?\nPor gentileza escolher o numero da funcao\n\n1. Cadastrar um cliente\n2. Listar todos os clientes cadastrados\n3. Buscar um cliente pelo nome")


-- variável que determina a escolha do usuario
local escolhaFuncao = tonumber(io.read()) -- usando o tonumber para converter para numero


-- irei colocar as 3 funções aqui 

-- começando pelo cadastro
function cadastroCliente()
-- definindo as variaveis para o cadastro
    print("Gentileza informar os seguintes dados: ")
    print("Nome: ") local nome = io.read()

    print("Data de nascimento (sem barras, apenas os numeros): ") local dataNascimento = io.read() -- eu sei que no desafio (criado por mim) estava idade, porém acredito que seja mais vaido a data de nasc
    
    local anoNascString =  ""
  
    
    -- dei uma pesquisada pra aprender isso,
    -- basicamente eu estou faznedo essa parte para conseguir calcular a idade da pessoa
    for i = 1, #dataNascimento do
      local digito = string.sub(dataNascimento, i, i) -- separo pelos digitos
      if i > 4 then -- passo pelos digitos, quando ultrapassar o quarto digito ele começa a concatenar com a outra variavel 
        anoNascString = anoNascString .. digito -- basicamente guarda os ultimos digitos (o ano)
      end
    end

    local anoNascimento = tonumber(anoNascString) -- guarda numa nova variavel, que agora é um número

    local ano = os.date("%Y") -- pega a data atual
    local idade = ano - anoNascimento -- diminui o ano atual pelo ano que nasceu e consegue a idade

    
    print("E-mail: ") local email = io.read()
    local emailValido = false -- variavel que define o email como não valido de inicio 

    -- aqui criei essa função para fazer uma verificação bem simples de e-mail, apenas para ver se possui o @
    function verificaEmail (email)
      for i = 1, #email do -- mesmo esquema de antes, passo pelos digitos
        local digito = string.sub(email, i, i)
        if digito == "@" then -- a diferença aqui é que só quero saber se possui ou não o @ 
          emailValido = true -- se possuir o e-mail é validado
        end
      end
    end

    verificaEmail(email) -- função ativada, fazendo a primeira verificação

    while emailValido == false do -- peço novamente o e-mail, até ser validado
      print("Por favor, informe um e-mail valido: ") email = io.read()
      verificaEmail(email)
    end


    -- lê os dados (se não tiver cria uma lista vazia)
    -- faço ler para garantir que posteriormente não vai descartar os dados salvos anteriormente
    local arquivo = io.open("clientes.json", "r")
    if arquivo then
      local conteudo = arquivo:read("*a")
      arquivo:close()
      clientes = json.decode(conteudo) or {}
    end

    -- adiciona o registro 
    table.insert(clientes, {nome = nome, idade = idade, dataNascimento = dataNascimento, email = email})

    -- salva os dados (sobreescreve)
    local dados_json = json.encode(clientes, { indent = true })
    arquivo = io.open("clientes.json", "w")
    arquivo:write(dados_json)
    arquivo:close()
end


-- listagem dos clientes
function listarClientes()

  -- acha e abre o arquivo
  local arquivo = io.open("clientes.json", "r")

  -- confere se funcionou
  if not arquivo then
    print("Arquivo nao encontrado!")
    return
  end

  -- lê o arquivo
  local conteudo = arquivo:read("*a")
  arquivo:close()

  -- converte JSON em tabela Lua
  local clientes, pos, err = json.decode(conteudo)

  -- confere se funcionou, igual antes
  if not clientes then  
    print("Erro ao decodificar JSON:", err)
  return
  end

  -- itera e imprime os dados
  for i, cliente in ipairs(clientes) do
    print("Cliente " .. i .. ":")
    -- para cada chave surge o valor em string
    for chave, valor in pairs(cliente) do
      print("  " .. chave .. ": " .. tostring(valor))
    end
  end
end



-- última função principal do sistema, buscar um cliente, pelo nome

function buscarCliente()
  
  -- variavel que define se foi ou nao encontrado pelo menos um cliente
  local clienteEncontrado = false -- vou usar ela no final da função


  -- sim eu sei que o certo seria usar um id único, porém como estou apenas testando a linguagem irei utilizar o nome mesmo
  print("Para buscar um cliente, por favor informe o seu nome completo: ") local busca = io.read()
  
  -- fazendo um processo parecido com o que fiz anteriormente 
  -- acha e abre o arquivo
  local arquivo = io.open("clientes.json", "r")

  -- confere se funcionou
  if not arquivo then
    print("Arquivo nao encontrado!")
    return
  end

  -- lê o arquivo
  local conteudo = arquivo:read("*a")
  arquivo:close()

  -- converte JSON em tabela Lua
  local clientes, pos, err = json.decode(conteudo)

  -- confere se funcionou, igual antes
  if not clientes then
    print("Erro ao decodificar JSON:", err)
  return
  end

  -- itera e imprime os dados
  for i, cliente in ipairs(clientes) do
    if cliente.nome == busca then
      print("Cliente encontrado!")
      clienteEncontrado = true
      for chave, valor in pairs(cliente) do
        print(chave .. ": " .. tostring(valor))
      end
    end
  end


  -- usando a variável para dar um retorno ao usuário 
  if clienteEncontrado == false then
    print("Nenhum cliente encontrado!")
  end
end


-- colocando a condição aqui, de acordo com a escolha do usuário irá para n função. Se a escolha não bater retorna um erro

if escolhaFuncao == 1 then
   cadastroCliente()
elseif escolhaFuncao == 2 then
   listarClientes()
elseif escolhaFuncao == 3 then
   buscarCliente()
else
  print("Erro! Escolha nao encontrada.")
end
