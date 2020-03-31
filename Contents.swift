//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

/* Queue global que executa tarefas na Main Thread, por default. Lembrando aqui que a Main Thread deve ser usada apenas para carregar a UI do app, uma vez que a prioridade é sempre a experiência do usuário e ninguem merece ficar esperando a tela carregar.
 É do tipo Serial Queue, e isso quer dizer que ela executa as tarefas dentro dela em sequência, uma tarefa atrás da outra.
 */
let mainQueue = DispatchQueue.main

/* No Xcode, existem por default 4 Concurrent Queues, ou seja queues que executam multiplas tarefas no mesmo bloco de código. Todas elas começam juntas, mas cada uma segue um curso diferente, não existe nenhuma garantia de quanto tempo cada uma vai durar, nem da ordem de execução das mesmas.

 Lembrando também, que elas possuiem por default uma ordem de prioridade de execução, o Quality of Service (QoS), é o quão rápido aquela queue executa suas tarefas. Em ordem crescente temos a baixo:
*/
let backgroundQueue = DispatchQueue.global(qos: .background) //Indexação, Sincronização, TUDO que não seja visível ao usuário.

let utilityQueue = DispatchQueue.global(qos: .utility) // Tarefas que não precisem de resultados imediatos, como baixar dados, geralmente vem acompanhadas de uma barra de progresso como feddback visual ao usuário

let initiatedQueue = DispatchQueue.global(qos: .userInitiated) // Abrir um documento salvo, eventos a partir de um clique de tela.

let interactiveQueue = DispatchQueue.global(qos: .userInteractive) // Tem a mesma prioridade que a main, é ideal para animações, dar refresh na interface, tudo de atividade que interaja com usuário.

// MARK: CRIANDO MINHA PRÓPRIA QUEUE
let myQueue = DispatchQueue(label: "myQueue")

// E para facilitar a nossa dev life, você consegue manipular suas queues para que elas sigam ordens de prioridade e execução, a partir da QoS.
let priorityQueue = DispatchQueue(label: "priorityQueue", qos: .userInteractive)

// MARK: COMO EXECUTAR FUNCÕES ASSÍNCRONAS
DispatchQueue.main.async {
}

backgroundQueue.async {
}

myQueue.async {
}

// MARK: TESTES COMO AS QUEUES SE COMPORTAM
//Para ver os resultados é só tirar os comentários das chamadas de função.

func syncQueues() {

    for i in 0...3 {
        print(i, "👩🏻‍🎤")
    }

    myQueue.sync {
        for i in 0...3{
            print(i, "👩🏻‍🦱")
        }
    }
}

//syncQueues()

func asyncQueues() {

    myQueue.async {
        for i in 0...3{
            print(i, "👑")
        }
    }

    for i in 0...3 {
        print(i, "👩🏾‍🌾")
    }
}

//asyncQueues()

func samePriorityQueues() {
    let queue = DispatchQueue(label: "queue", qos: .userInteractive)
    let queue2 = DispatchQueue(label: "queue2", qos: .userInteractive)

    queue.async {
        for i in 0...3{
            print(i, "👑")
        }
    }

    queue2.async {
        for i in 0...3{
            print(i, "👩🏾‍🌾")
        }
    }
}

//samePriorityQueues()

func diffentPriorityQueues() {
    let queue = DispatchQueue(label: "queue", qos: .userInitiated)
    let queue2 = DispatchQueue(label: "queue2", qos: .utility)

    queue.async {
        for i in 0...3{
            print(i, "👑")
        }
    }

    queue2.async {
        for i in 0...3{
            print(i, "👩🏾‍🌾")
        }
    }
}

//diffentPriorityQueues()

func testQoS() {

    interactiveQueue.async {
        for i in 0...3{
            print(i, "🐇")
        }
    }

    initiatedQueue.async {
        for i in 0...3{
            print(i, "🐿")
        }
    }

    utilityQueue.async {
        for i in 0...3{
            print(i, "🐌")
        }
    }

    backgroundQueue.async {
        for i in 0...3{
            print(i, "🐢")
        }
    }
}

//testQoS()

// MARK: NÃO FAÇA ISSO!
//Lembrando aqui, qualquer alteração visual é na main!

let view = UIView()

func getData() {
    //algum código que pega dados do servidor
}

func dontDoThis(){
    mainQueue.async {
        getData()
        view.backgroundColor = .red
    }
}

// MARK: AO INVÉS, FAÇA ISSO
func doThisInstead() {
    myQueue.async {
        getData()
    }

    mainQueue.async {
        view.backgroundColor = .red
    }
}

// MARK: DESCOBRINDO EM QUE THREAD VOCÊ ESTÁ
print("current function is \(#function) in thread \(Thread.current)")




