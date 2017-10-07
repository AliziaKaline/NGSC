/*
SQLyog Community v12.4.3 (64 bit)
MySQL - 5.7.16-log 
*********************************************************************
*/
/*!40101 SET NAMES utf8 */;

UPDATE `creature_template` SET `AIName`='EventAI' WHERE `Entry` = '7461';

insert into `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) values('74610','7461','9','0','100','1','3','40','2000','2500','11','24668','1','1','0','0','0','0','0','0','0','0','Casting Shadowbolt if range is greater than 3 meters and lower than 40');

insert into `creature_template_spells` (`entry`, `spell1`, `spell2`, `spell3`, `spell4`) values('7461','24668','0','0','0');
