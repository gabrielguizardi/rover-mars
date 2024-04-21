# Rover Mars

## Como clonar e executar o projeto

1. Clone o repositório para a sua máquina local usando `git clone git@github.com:gabrielguizardi/rover-mars.git`.
2. Navegue até a pasta do projeto usando `cd rover-mars`.
3. Execute o projeto usando `ruby ./app/command_center.rb`.

## Como executar os testes automatizados

1. Na pasta do projeto, execute `rspec` para rodar os testes automatizados.

## Problema

Um esquadrão de rovers robóticos será pousado pela NASA em um planalto em Marte. Este planalto, que é curiosamente retangular, deve ser navegado pelos rovers para que suas câmeras embarcadas possam obter uma visão completa do terreno ao redor para enviar de volta à Terra.

A posição e localização de um rover é representada por uma combinação de coordenadas x e y e uma letra representando um dos quatro pontos cardeais. O planalto é dividido em uma grade para simplificar a navegação. Um exemplo de posição pode ser 0, 0, N, o que significa que o rover está no canto inferior esquerdo e voltado para o Norte.

Para controlar um rover, a NASA envia uma simples string de letras. As possíveis letras são 'L', 'R' e 'M'. 'L' e 'R' fazem o rover girar 90 graus para a esquerda ou direita, respectivamente, sem se mover do seu local atual. 'M' significa mover-se um ponto da grade para a frente, mantendo a mesma direção.

Assuma que o quadrado diretamente ao Norte de (x, y) é (x, y+1).

## Entrada

A primeira linha de entrada são as coordenadas superiores direitas do planalto, as coordenadas inferiores esquerdas são assumidas como 0,0.

O restante da entrada é informação pertinente aos rovers que foram implantados. Cada rover tem duas linhas de entrada. A primeira linha dá a posição do rover, e a segunda linha é uma série de instruções dizendo ao rover como explorar o planalto.

A posição é composta por dois inteiros e uma letra separados por espaços, correspondendo às coordenadas x e y e à orientação do rover.

Cada rover será finalizado sequencialmente, o que significa que o segundo rover não começará a se mover até que o primeiro tenha terminado de se mover.

## Saída

A saída para cada rover deve ser suas coordenadas finais e direção.