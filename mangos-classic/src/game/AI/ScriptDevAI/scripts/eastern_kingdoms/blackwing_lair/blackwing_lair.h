/* This file is part of the ScriptDev2 Project. See AUTHORS file for Copyright information
 * This program is free software licensed under GPL version 2
 * Please see the included DOCS/LICENSE.TXT for more information */

#ifndef DEF_BLACKWING_LAIR
#define DEF_BLACKWING_LAIR

enum
{
    MAX_ENCOUNTER               = 9,

    TYPE_RAZORGORE              = 0,
    TYPE_VAELASTRASZ            = 1,
    TYPE_LASHLAYER              = 2,
    TYPE_FIREMAW                = 3,
    TYPE_EBONROC                = 4,
    TYPE_FLAMEGOR               = 5,
    TYPE_CHROMAGGUS             = 6,
    TYPE_NEFARIAN               = 7,
    TYPE_QUEST_SCEPTER          = 8,

    DATA_DRAGON_EGG             = 1,                        // track the used eggs

    NPC_RAZORGORE               = 12435,
    NPC_VAELASTRASZ             = 13020,
    NPC_LASHLAYER               = 12017,
    NPC_FIREMAW                 = 11983,
    NPC_EBONROC                 = 14601,
    NPC_FLAMEGOR                = 11981,
    NPC_CHROMAGGUS              = 14020,
    NPC_NEFARIAN                = 11583,
    NPC_LORD_VICTOR_NEFARIUS    = 10162,

    // Razorgore event related
    NPC_GRETHOK_CONTROLLER      = 12557,
    NPC_BLACKWING_ORB_TRIGGER   = 14449,
    NPC_NEFARIANS_TROOPS        = 14459,
    NPC_MONSTER_GENERATOR       = 12434,
    NPC_ORB_DOMINATION          = 14453,
    NPC_BLACKWING_LEGIONNAIRE   = 12416,                    // one spawn per turn
    NPC_BLACKWING_MAGE          = 12420,                    // one spawn per turn
    NPC_DRAGONSPAWN             = 12422,                    // two spawns per turn

    GO_DOOR_RAZORGORE_ENTER     = 176964,
    GO_DOOR_RAZORGORE_EXIT      = 176965,
    GO_DOOR_NEFARIAN            = 176966,
    // GO_DOOR_CHROMAGGUS_ENTER  = 179115,
    // GO_DOOR_CHROMAGGUS_SIDE   = 179116,
    GO_DOOR_CHROMAGGUS_EXIT     = 179117,
    GO_DOOR_VAELASTRASZ         = 179364,
    GO_DOOR_LASHLAYER           = 179365,
    GO_ORB_OF_DOMINATION        = 177808,                   // trigger 19832 on Razorgore
    GO_BLACK_DRAGON_EGG         = 177807,
    GO_DRAKONID_BONES           = 179804,
    GO_SUPPRESSION_DEVICE       = 179784,                   // Traps in Suppression Room

    EMOTE_ORB_SHUT_OFF          = -1469035,
    EMOTE_TROOPS_FLEE           = -1469033,                 // emote by Nefarian's Troops npc
    SAY_RAZORGORE_DEATH         = -1469025,

    // Spells used by the monster generator in Razorgore encounter
    // SPELL_SUMMON_LEGIONNAIRES   = 19824,                    // Periodically triggers 19826
    SPELL_SUMMON_LEGIONNAIRE    = 19826,
    SPELL_SUMMON_MAGE           = 19827,
    SPELL_SUMMON_DRAGONSPAWN    = 19828,
    SPELL_WARMING_FLAMES        = 23040,                    // Used by Razorgore to fully heal in in phase 1 to 2 transition
    SPELL_CONTROL_ORB           = 23018,                    // Visual used by Grethok the Controller
    SPELL_FIREBALL              = 23024,                    // Used by Razorgore to reset the event (and kill everyone like a badass)
    SPELL_EXPLODE_ORB           = 20037,                    // used if attacked without destroying the eggs - triggers 20038

    MAX_EGGS_DEFENDERS          = 4,
    MAX_DRAGONSPAWN             = 12,
    MAX_BLACKWING_DEFENDER      = 40,

    // Yells by Nefarian during the epic quest Nefarius' Corruption
    YELL_REDSHARD_TAUNT_1       = -1469036,
    YELL_REDSHARD_TAUNT_2       = -1469037,
    YELL_REDSHARD_TAUNT_3       = -1469039,
    YELL_REDSHARD_TAUNT_4       = -1469040,
    YELL_REDSHARD_TAUNT_5       = -1469041,
    YELL_REDSHARD_TAUNT_6       = -1469042,
    YELL_REDSHARD_TAUNT_7       = -1469043,
    EMOTE_REDSHARD_TAUNT_1      = -1469038,
    EMOTE_REDSHARD_TAUNT_2      = -1469044,
};

// Coords used in intro event for Vaelastrasz to spawn Nefarius at the throne and sort the gobelins
static const float aNefariusSpawnLoc[4] = { -7466.16f, -1040.80f, 412.053f, 2.14675f};
static const float fVaelXPos = -7483.0f;

class instance_blackwing_lair : public ScriptedInstance
{
    public:
        instance_blackwing_lair(Map* pMap);
        ~instance_blackwing_lair() {}

        void Initialize() override;
        bool IsEncounterInProgress() const override;

        void OnCreatureCreate(Creature* pCreature) override;
        void OnObjectCreate(GameObject* pGo) override;

        void OnCreatureEnterCombat(Creature* pCreature) override;
        void OnCreatureDeath(Creature* pCreature) override;

        void SetData(uint32 uiType, uint32 uiData) override;
        uint32 GetData(uint32 uiType) const override;

        void SetData64(uint32 uiData, uint64 uiGuid) override;

        const char* Save() const override { return m_strInstData.c_str(); }
        void Load(const char* chrIn) override;

        void Update(uint32 uiDiff) override;

        bool CheckConditionCriteriaMeet(Player const* pPlayer, uint32 uiInstanceConditionId, WorldObject const* pConditionSource, uint32 conditionSourceType) const override;

    protected:
        std::string m_strInstData;
        uint32 m_auiEncounter[MAX_ENCOUNTER];

        uint32 m_uiResetTimer;
        uint32 m_uiDefenseTimer;
        uint32 m_uiScepterEpicTimer;
        uint8 m_uiScepterQuestStep;
        uint32 m_uiDragonspawnCount;
        uint32 m_uiBlackwingDefCount;

        bool m_bIsMainGateOpen;

        GuidList m_lDragonEggsGuids;
        GuidList m_lDrakonidBonesGuids;
        GuidList m_lDefendersGuids;
        GuidList m_lUsedEggsGuids;
        GuidVector m_vGeneratorGuids;
};

#endif
