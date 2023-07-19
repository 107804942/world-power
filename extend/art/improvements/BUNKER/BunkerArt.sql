-- Insert SQL Rules Here 

----------------------------------------------------------
-- ArtDefine_Landmarks
----------------------------------------------------------

INSERT INTO ArtDefine_LandmarkTypes(Type, LandmarkType, FriendlyName)
SELECT 'ART_DEF_IMPROVEMENT_BUNKER', 'Improvement', 'Bunker';

INSERT INTO ArtDefine_Landmarks(Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour)
SELECT 'Any', 'UnderConstruction', 1.25,  'ART_DEF_IMPROVEMENT_BUNKER', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'Bunker_HB.fxsxml', 1 UNION ALL
SELECT 'Any', 'Constructed',       1.25,  'ART_DEF_IMPROVEMENT_BUNKER', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'Bunker_B.fxsxml',    1 UNION ALL
SELECT 'Any', 'Pillaged',          1.25,  'ART_DEF_IMPROVEMENT_BUNKER', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'Bunker_PL.fxsxml', 1;

INSERT INTO ArtDefine_StrategicView(StrategicViewType, TileType, Asset)
SELECT 'ART_DEF_IMPROVEMENT_BUNKER', 'Improvement', 'SV_Bunker256.dds';