//
//  yonderTests.swift
//  yonderTests
//
//  Created by Andre Pham on 17/11/21.
//

import XCTest
@testable import yonder

class yonderTests: XCTestCase {

    func testActorHealth() throws {
        let actor = ActorAbstract(maxHealth: 500)
        actor.setHealth(to: 250)
        XCTAssertEqual(actor.health, 250)
        actor.damage(for: 50)
        XCTAssertEqual(actor.health, 200)
        actor.heal(for: 500)
        XCTAssertEqual(actor.health, actor.maxHealth)
    }
    
    func testAttack() throws {
        let player = Player(maxHealth: 200)
        let foe = FoeAbstract(maxHealth: 200, weapon: BaseAttack(damage: 5))
        foe.attack(target: player, weapon: foe.getWeapon())
        XCTAssertTrue(player.health == 195)
    }
    
    func testDeath() throws {
        let player = Player(maxHealth: 200)
        player.damage(for: 150)
        XCTAssertTrue(!player.isDead)
        player.damage(for: 150)
        XCTAssertTrue(player.isDead)
    }
    
    func testStatusEffects() throws {
        let player = Player(maxHealth: 200)
        player.addStatusEffect(BurnStatusEffect(damage: 5))
        player.triggerStatusEffects()
        XCTAssertTrue(player.health == 195)
    }
    
    func testTimedEvents() throws {
        let player = Player(maxHealth: 200)
        player.damage(for: 150)
        let timedEvent = FullHealTimedEvent(timeToTrigger: 2, target: player)
        player.addTimedEvent(timedEvent)
        player.decrementTimedEvents()
        XCTAssertTrue(player.health == 50)
        XCTAssertTrue(player.timedEvents.count == 1)
        player.decrementTimedEvents()
        XCTAssertTrue(player.health == 200)
        XCTAssertTrue(player.timedEvents.count == 0)
    }
    
    func testBuffs() throws {
        let player = Player(maxHealth: 200)
        let foe = FoeAbstract(maxHealth: 200, weapon: BaseAttack(damage: 5))
        foe.addBuff(DoubleDamageBuff(duration: 5))
        foe.addBuff(DoubleDamageBuff(duration: 5))
        foe.attack(target: player, weapon: foe.getWeapon())
        XCTAssertTrue(player.health == 180)
    }

}