UPDATE creature_template SET UnitFlags=33555200 WHERE Entry=14081;
UPDATE creature_template_addon SET bytes1=0 WHERE entry=13020;

UPDATE creature SET spawntimesecsmin = 10, spawntimesecsmax = 10 WHERE id IN (14449, 14459, 16604);
UPDATE creature_template SET scale=3 WHERE entry=16604;
-- Fixed NPC 12434 (Monster Generator) being selectable
UPDATE creature_template SET UnitFlags=33587200 WHERE Entry=12434;

-- Added missing target for spell 23024 (Fireball)
DELETE FROM spell_script_target WHERE entry=23024;
INSERT INTO spell_script_target VALUES(23024, 1, 14449, 0);

-- Prevented Grethok and its adds to respawn while Razorgore is dead
UPDATE creature_linking_template SET flag=flag+1024 WHERE master_entry IN (12557, 12435);

SET @COND := 1395;
DELETE FROM conditions WHERE condition_entry IN (@COND, @COND + 1);
INSERT INTO conditions VALUES
(@COND, 9, 8730, 0, 'Has taken quest Nefarius Corruption'),
(@COND + 1, -1, @COND, 734, 'Has taken quest 8730 and event failed'),
(@COND + 2, -1, @COND, 735, 'Has taken quest 8730 and event succeed');

UPDATE creature_loot_template SET ChanceOrQuestChance=100, condition_id = @COND + 1 where item=21142;
UPDATE creature_loot_template SET ChanceOrQuestChance=100, condition_id = @COND + 2 where item=21138;