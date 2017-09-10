/* A noter que l'item nécessite un gob pour être lancé, on va d'abord placer ces gobs */
INSERT INTO `gameobject` (`id`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecsmin`, `spawntimesecsmax`, `animprogress`, `state`) VALUES (300046, 30, -283.303, -319.038, 4.89198, 1.7789, 0, 0, 0.776727, 0.629838, 25, 25, 100, 1);
INSERT INTO `gameobject` (`id`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecsmin`, `spawntimesecsmax`, `animprogress`, `state`) VALUES (300039, 30, -283.303, -319.038, 4.89198, 1.7789, 0, 0, 0.776727, 0.629838, 25, 25, 100, 1);
INSERT INTO `gameobject` (`id`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecsmin`, `spawntimesecsmax`, `animprogress`, `state`) VALUES (300047, 30, -237.043, -257.606, 4.01985, 0.67699, 0, 0, 0.332068, 0.943256, 25, 25, 100, 1);
INSERT INTO `gameobject` (`id`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecsmin`, `spawntimesecsmax`, `animprogress`, `state`) VALUES (300040, 30, -237.043, -257.606, 4.01985, 0.67699, 0, 0, 0.332068, 0.943256, 25, 25, 100, 1);
INSERT INTO `gameobject` (`id`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecsmin`, `spawntimesecsmax`, `animprogress`, `state`) VALUES (300045, 30, -204.586, -113.444, 78.556, 5.79622, 0, 0, 0.241085, -0.970504, 25, 25, 100, 1);
INSERT INTO `gameobject` (`id`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecsmin`, `spawntimesecsmax`, `animprogress`, `state`) VALUES (300041, 30, -204.586, -113.444, 78.556, 5.79622, 0, 0, 0.241085, -0.970504, 25, 25, 100, 1);
/* Aerie Gryphon - Correction du creature_template : Faction Stormpike - Fly over everything - Unattackable and Passive - Can't melee - Flyspeed to 5 - EventAI */
UPDATE `mangos`.`creature_template` SET `FactionAlliance`='1216', `FactionHorde`='1216', `InhabitType`='7', `UnitFlags`='33408', `ExtraFlags`='131072', `SpeedWalk`='5', `AIName`='EventAI' WHERE  `Entry`=13161;
/* Aerie Gryphon - Ajout de l'EventAI : */
INSERT INTO `creature_ai_scripts` VALUES (13161, 11, 0, 100, 0, 0, 0, 0, 0, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Aerie Gryphon - Should not go in melee range');
INSERT INTO `creature_ai_scripts` VALUES (13161, 0, 0, 100, 33, 5000, 10000, 5000, 10000, 11, 21188, 4, 0, 11, 22088, 4, 0, 0, 0, 0, 0, 'Aerie Gryphon - Cast Random spell in combat');
INSERT INTO `creature_ai_scripts` VALUES (13161, 10, 0, 100, 33, 1, 100, 5000, 10000, 11, 21188, 4, 0, 11, 22088, 4, 0, 0, 0, 0, 0, 'Aerie Gryphon - Cast Random spell at aggro');
INSERT INTO `creature_ai_scripts` VALUES (13161, 11, 0, 100, 0, 0, 0, 0, 0, 11, 4986, 0, 39, 0, 0, 0, 0, 0, 0, 0, 0, 'Aerie Gryphon - Invisible before Event');
/* On va passer aux script de chacun des events */
/*-----SLIDORE-----*/
/* Il nous faut quelques variables */
SET @SlidoreB:= ( SELECT MAX(guid) FROM gameobject )+1;
SET @SlidoreG:= ( SELECT MAX(guid) FROM creature )+1;
/* On commence par mettre en place l'event lancé par l'item (Slidore's Beacon) */
/* On a besoin de mettre en place le GOB mais qu'il ne soit pas spawn de base */
INSERT INTO `gameobject` VALUES (@SlidoreB ,178725, 30, -283.484, -319.142, 4.90878, 1.15373, 0, 0, 0.545401, 0.838175, -7200, -7200, 100, 1);
/* A l'utilisation du GOB (par la horde) il faut tuer le trigger qui sert de check */
INSERT INTO `dbscripts_on_go_template_use` VALUES (178725, 0, 18, 0, 0, 0, 15384, 10, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Slidore\'s Beacon - Kill trigger at use');
/* On spawn le trigger qui va servir de check */
INSERT INTO `dbscripts_on_event` VALUES (7323, 0, 10, 15384, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Slidore\'s Beacon - Trigger\'s spawn');
/* On fait apparaître le GOB */
INSERT INTO `dbscripts_on_event` VALUES (7323, 0, 9, @SlidoreB, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Slidore\'s Beacon - Beacon\'s spawn');
/* On check si le trigger est encore là avant de faire apparaître le Gryphon */
INSERT INTO `dbscripts_on_event` VALUES (7323, 59, 31, 15384, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Slidore\'s Beacon - IF Trigger = Dead then stop event');
/* Si c'est bon, on rend le gryphon visible et on lui retire le flag "passif" */
INSERT INTO `dbscripts_on_event` VALUES (7323, 60, 5, 46, 512, 0, 13161, @SlidoreG, 80, 0, 0, 0, 0, 0, 0, 0, 0, 'Slidore\'s Beacon - Gryphon Spawn - Remove Passive Flag');
INSERT INTO `dbscripts_on_event` VALUES (7323, 60, 14, 4986, 0, 0, 13161, @SlidoreG, 80, 0, 0, 0, 0, 0, 0, 0, 0, 'Slidore\'s Beacon - Gryphon Spawn - Set visible');
/* GOB : Il faut corriger le gameobject_template pour qu'il ne soit utilisable que par la horde */
UPDATE `mangos`.`gameobject_template` SET `faction`='29' WHERE  `entry`=178725;
/* Il faut maintenant pop le gryphon, et lui mettre des waypoints */
INSERT INTO `creature` VALUES (@SlidoreG, 13161, 30, 0, 0, -278.499, -325.661, 30, 3.66701, 1000000, 1000000, 100, 1, 19800, 0, 0, 2);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 1, -284.228, -327.893, 31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.69293, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 2, -297.629, -337.22, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.1359, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 3, -305.727, -352.608, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.54038, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 4, -310.019, -383.775, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.69903, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 5, -328.602, -405.588, 34, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.43454, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 6, -307.162, -453.496, 47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6.04457, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 7, -267.788, -463.598, 54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.15487, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 8, -216.391, -459.402, 51, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.95739, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 9, -123.523, -480.853, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.382636, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 10, -93.8998, -429.329, 41, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.42329, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 11, -79.8892, -386.675, 38, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.723499, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 12, -63.6874, -342.076, 36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.05004, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 13, -107.688, -309.433, 33, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.93597, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 14, -149.517, -313.773, 34, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.11975, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 15, -209.825, -321.678, 31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.15745, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 16, -243.406, -324.81, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.15745, 0, 0);
INSERT INTO `creature_movement` VALUES (@SlidoreG, 17, -260.945, -327.447, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.33024, 0, 0);
/*-----VIPORE-----*/
/* Il nous faut quelques variables */
SET @ViporeB:= ( SELECT MAX(guid) FROM gameobject )+1;
SET @ViporeG:= ( SELECT MAX(guid) FROM creature )+1;
/* On commence par mettre en place l'event lancé par l'item (Vipore's Beacon) */
/* On a besoin de mettre en place le GOB mais qu'il ne soit pas spawn de base */
INSERT INTO `gameobject` VALUES (@ViporeB ,178724, 30, -237.455, -258.548, 3.8066, 2.5973, 0, 0, 0.963196, 0.268799, -7200, -7200, 100, 1);
/* A l'utilisation du GOB (par la horde) il faut tuer le trigger qui sert de check */
INSERT INTO `dbscripts_on_go_template_use` VALUES (178724, 0, 18, 0, 0, 0, 15384, 10, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Vipore\'s Beacon - Kill trigger at use');
/* On spawn le trigger qui va servir de check */
INSERT INTO `dbscripts_on_event` VALUES (7327, 0, 10, 15384, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Vipore\'s Beacon - Trigger\'s spawn');
/* On fait apparaître le GOB */
INSERT INTO `dbscripts_on_event` VALUES (7327, 0, 9, @ViporeB, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Vipore\'s Beacon - Beacon\'s spawn');
/* On check si le trigger est encore là avant de faire apparaître le Gryphon */
INSERT INTO `dbscripts_on_event` VALUES (7327, 59, 31, 15384, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Vipore\'s Beacon - IF Trigger = Dead then stop event');
/* Si c'est bon, on rend le gryphon visible et on lui retire le flag "passif" */
INSERT INTO `dbscripts_on_event` VALUES (7327, 60, 5, 46, 512, 0, 13161, @ViporeG, 80, 0, 0, 0, 0, 0, 0, 0, 0, 'Vipore\'s Beacon - Gryphon Spawn - Remove Passive Flag');
INSERT INTO `dbscripts_on_event` VALUES (7327, 60, 14, 4986, 0, 0, 13161, @ViporeG, 80, 0, 0, 0, 0, 0, 0, 0, 0, 'Vipore\'s Beacon - Gryphon Spawn - Set visible');
/* GOB : Il faut corriger le gameobject_template pour qu'il ne soit utilisable que par la horde */
UPDATE `mangos`.`gameobject_template` SET `faction`='29' WHERE  `entry`=178724;
/* Il faut maintenant pop le gryphon, et lui mettre des waypoints */   /* Modif des WP IG */
INSERT INTO `creature` VALUES (@ViporeG, 13161, 30, 0, 0, -184.141, -278.208, 31.66758, 2.23994, 1000000, 1000000, 100, 1, 19800, 0, 0, 2);
INSERT INTO `creature_movement` VALUES (@ViporeG, 1, -191.532, -269.701, 31.6676, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.38603, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 2, -207.455, -254.701, 31.6676, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.38603, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 3, -227.262, -238.423, 31.6676, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.42373, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 4, -248.238, -220.949, 31.8277, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.53447, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 5, -265.744, -208.788, 32.4038, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.53447, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 6, -286.134, -192.451, 33.2528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.31535, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 7, -301.183, -181.605, 34.2074, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.26587, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 8, -312.116, -164.267, 34.2762, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.8606, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 9, -312.454, -139.865, 37.9976, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.67682, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 10, -312.668, -106.122, 44.6445, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.64147, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 11, -318.721, -81.8502, 50.0354, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.75222, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 12, -312.813, -64.7138, 52.5257, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.8333, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 13, -287.952, -49.9546, 56.3879, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.4783, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 14, -260.572, -44.1391, 61.6446, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.011773, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 15, -238.684, -46.6273, 62.792, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6.07426, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 16, -217.501, -56.3464, 63.1325, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.96352, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 17, -195.032, -64.7979, 60.1933, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.74204, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 18, -167.897, -78.7873, 56.4536, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.669, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 19, -144.824, -97.7801, 54.2753, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.37447, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 20, -137.397, -118.844, 51.4326, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.00691, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 21, -132.539, -148.989, 44.2745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.93622, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 22, -123.792, -187.413, 43.0181, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.93622, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 23, -112.332, -224.877, 43.089, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.15534, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 24, -106.027, -249.378, 33.3359, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.05657, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 25, -123.358, -271.902, 31.6889, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.05657, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 26, -140.173, -282.157, 31.8746, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.46753, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 27, -162.117, -288.688, 34.8808, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.24604, 0, 0);
INSERT INTO `creature_movement` VALUES (@ViporeG, 28, -183.624, -276.81, 31.6676, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.3499, 0, 0);
/*-----ICHMAN-----*/
/* Il nous faut quelques variables */
SET @IchmanB:= ( SELECT MAX(guid) FROM gameobject )+1;
SET @IchmanG:= ( SELECT MAX(guid) FROM creature )+1;
/* On commence par mettre en place l'event lancé par l'item (Ichman's Beacon) */
/* On a besoin de mettre en place le GOB mais qu'il ne soit pas spawn de base */
INSERT INTO `gameobject` VALUES (@IchmangameobjectB ,178726, 30, -200.77, -121.755, 78.3324, 2.24937, 0, 0, 0.902132, 0.431461, -7200, -7200, 100, 1);
/* A l'utilisation du GOB (par la horde) il faut tuer le trigger qui sert de check */
INSERT INTO `dbscripts_on_go_template_use` VALUES (178726, 0, 18, 0, 0, 0, 15384, 10, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ichman\'s Beacon - Kill trigger at use');
/* On spawn le trigger qui va servir de check */
INSERT INTO `dbscripts_on_event` VALUES (7319, 0, 10, 15384, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Ichman\'s Beacon - Trigger\'s spawn');
/* On fait apparaître le GOB */
INSERT INTO `dbscripts_on_event` VALUES (7319, 0, 9, @IchmanB, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Ichman\'s Beacon - Beacon\'s spawn');
/* On check si le trigger est encore là avant de faire apparaître le Gryphon */
INSERT INTO `dbscripts_on_event` VALUES (7319, 59, 31, 15384, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Ichman\'s Beacon - IF Trigger = Dead then stop event');
/* Si c'est bon, on rend le gryphon visible et on lui retire le flag "passif" */
INSERT INTO `dbscripts_on_event` VALUES (7319, 60, 5, 46, 512, 0, 13161, @IchmanG, 80, 0, 0, 0, 0, 0, 0, 0, 0, 'Ichman\'s Beacon - Gryphon Spawn - Remove Passive Flag');
INSERT INTO `dbscripts_on_event` VALUES (7319, 60, 14, 4986, 0, 0, 13161, @IchmanG, 80, 0, 0, 0, 0, 0, 0, 0, 0, 'Ichman\'s Beacon - Gryphon Spawn - Set visible');
/* GOB : Il faut corriger le gameobject_template pour qu'il ne soit utilisable que par la horde */
UPDATE `mangos`.`gameobject_template` SET `faction`='29' WHERE  `entry`=178726;
/* Il faut maintenant pop le gryphon, et lui mettre des waypoints */
INSERT INTO `creature` VALUES (@IchmanG, 13161, 30, 0, 0, -155.255, -233.933, 34.1167, 5.10115, 1000000, 1000000, 100, 1, 19800, 0, 0, 2);
INSERT INTO `creature_movement` VALUES (@IchmanG, 1, -155.255, -233.933, 34.1167, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.10115, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 2, -149.482, -261.624, 32.0014, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.20011, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 3, -139.739, -279.99, 31.8071, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.49542, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 4, -120.677, -296.096, 34.4818, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.69648, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 5, -70.5448, -329.424, 36.9601, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.45143, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 6, -53.7316, -370.144, 37.8318, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.00847, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 7, -38.6372, -402.402, 51.1407, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.30064, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 8, -17.2163, -417.156, 68.076, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.183769, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 9, 12.1006, -404.535, 70.2768, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.662862, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 10, 48.0868, -390.481, 70.4177, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6.2816, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 11, 106.599, -385.101, 70.0431, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.217541, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 12, 130.247, -381.595, 67.501, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.66585, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 13, 153.03, -396.224, 67.7663, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.96116, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 14, 203.822, -413.081, 67.4969, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6.18107, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 15, 231.049, -415.871, 63.6913, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.045539, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 16, 258.254, -413.035, 54.5847, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.679355, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 17, 268.149, -403.012, 45.3331, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.958957, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 18, 289.457, -386.119, 29.7839, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.345561, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 19, 323.935, -385.487, 24.3556, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6.13787, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 20, 345.614, -388.659, 24.5282, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6.13787, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 21, 371.587, -392.46, 24.5788, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.146855, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 22, 392.223, -389.408, 23.7562, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.146855, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 23, 429.173, -380.715, 23.7562, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.291369, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 24, 462.862, -368.292, 23.7562, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.732763, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 25, 487.214, -346.378, 23.7562, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.732763, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 26, 508.617, -331.978, 23.9149, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.329853, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 27, 531.987, -322.531, 27.0078, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.179057, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 28, 550.907, -321.889, 36.4665, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6.03813, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 29, 570.532, -326.797, 48.3342, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.69569, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 30, 581.91, -333.047, 54.3219, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6.03813, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 31, 603.602, -336.595, 55.3833, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.308647, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 32, 613.81, -331.629, 55.3002, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.739046, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 33, 627.517, -319.08, 55.1346, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.05949, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 34, 635.477, -304.152, 55.1336, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.28097, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 35, 636.539, -288.457, 55.1375, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.57314, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 36, 631.295, -231.999, 62.4501, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.71765, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 37, 624.97, -189.239, 63.6482, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.71765, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 38, 619.193, -136.73, 58.4222, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.41056, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 39, 629.172, -109.923, 63.6512, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.15983, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 40, 607.655, -104.558, 65.6927, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.21541, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 41, 595.797, -124.459, 65.6989, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.64857, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 42, 616.27, -128.866, 59.2874, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6.07897, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 43, 619.475, -141.584, 58.4467, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.79641, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 44, 622.231, -174.298, 62.244, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.79641, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 45, 627.508, -205.408, 64.0871, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.79641, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 46, 635.246, -265.657, 56.2364, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.87338, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 47, 636.719, -296.645, 55.134, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.49639, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 48, 630.852, -313.486, 55.134, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.07856, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 49, 618.599, -328.792, 55.134, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.79739, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 50, 607.965, -334.055, 55.5824, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.60261, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 51, 590.126, -336.244, 55.1336, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.64599, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 52, 573.453, -330.789, 50.3594, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.58552, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 53, 556.296, -322.753, 39.9139, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.88083, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 54, 537.669, -321.902, 29.1064, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.15179, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 55, 514.366, -329.276, 23.9157, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.50758, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 56, 493.982, -341.826, 23.8191, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.76676, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 57, 469.374, -363.325, 23.7562, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.74084, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 58, 438.955, -377.935, 23.7562, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.43454, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 59, 403.442, -386.524, 23.7562, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.44632, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 60, 371.312, -392.343, 24.6002, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.1243, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 61, 345.02, -388.383, 24.5087, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.93973, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 62, 324.611, -384.246, 24.2444, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.11331, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 63, 303.794, -383.657, 25.4425, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.11331, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 64, 281.501, -389.807, 33.1489, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.55392, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 65, 265.143, -402.089, 46.6721, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.13904, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 66, 257.787, -411.533, 54.2297, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.68272, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 67, 230.43, -417.404, 63.6764, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.88711, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 68, 202.959, -410.258, 67.6864, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.88711, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 69, 165.361, -398.877, 67.7709, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.9633, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 70, 137.883, -386.482, 67.436, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.57138, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 71, 120.057, -359.741, 68.0593, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.98076, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 72, 103.689, -325.41, 62.6608, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.90772, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 73, 95.0224, -300.669, 56.1359, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.90772, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 74, 85.5385, -276.28, 49.6315, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.05616, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 75, 68.5102, -257.939, 43.4821, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.71825, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 76, 44.3402, -247.75, 40.2915, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.06304, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 77, 19.388, -245.183, 39.0401, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.84156, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 78, -8.9612, -237.082, 35.931, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.13609, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 79, -33.7149, -231.655, 35.2128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.29631, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 80, -56.4006, -235.193, 35.005, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.28845, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 81, -86.2163, -238.883, 34.3756, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.72689, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 82, -107.841, -227.449, 42.0123, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.76302, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 83, -133.95, -214.095, 34.4934, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.28295, 0, 0);
INSERT INTO `creature_movement` VALUES (@IchmanG, 84, -150.126, -219.094, 42.5331, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3.8508, 0, 0);