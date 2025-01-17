//
//  JuiceMaker - JuiceMaker.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import Foundation

// 쥬스 메이커 타입
struct JuiceMaker: Makeable {
    let fruitStore = FruitStore.shared
    
    func make(single juice: SingleFruitJuice) {
        switch juice {
        case .strawberry:
            blending(juice: .strawberry)
            break
        case .banana:
            blending(juice: .banana)
            break
        case .pineApple:
            blending(juice: .pineApple)
            break
        case .kiwi:
            blending(juice: .kiwi)
            break
        case .mango:
            blending(juice: .mango)
            break
        }
    }
    
    func make(mix juice: MixFruitJuice) {
        switch juice {
        case .strawberryBanana:
            blending(juice: .strawberryBanana)
            break
        case .mangoKiwi:
            blending(juice: .mangoKiwi)
            break
        }
    }
    
    func isMakeable(_ juice: SingleFruitJuice, send consume: Int) -> Bool {
        var isContinue = false
        
        juice.recipe.forEach { fruit in
            isContinue = fruitStore.isRemainFruit(type: fruit.key, count: consume)
        }
        return isContinue
    }
    
    func isMakeable(_ juice: MixFruitJuice, send consumes: [Int]) -> Bool {
        var isContinue = [true]
        var needCounts = consumes
        
        juice.recipe.forEach { fruit in
            guard let extractCount = needCounts.first else {
                return
            }
            let discern = fruitStore.isRemainFruit(type: fruit.key, count: extractCount)
            isContinue.append(discern)
            needCounts.removeFirst()
        }
        guard isContinue.contains(false) else {
            return true
        }
        return false
    }
    
    private func blending(juice: SingleFruitJuice) {
        let needToMakeJuiceCount = fruitStore.needCountOfMake(to: juice)
        
        juice.recipe.forEach { fruit in
            fruitStore.update(fruit.key, stock: needToMakeJuiceCount)
        }
    }
    
    private func blending(juice: MixFruitJuice) {
        var needCounts = fruitStore.needCountOfMake(to: juice)
        
        juice.recipe.forEach { fruit in
            guard let extractCount = needCounts.first else {
                return
            }
            fruitStore.update(fruit.key, stock: extractCount)
            needCounts.removeFirst()
        }
    }
}
