using System;

namespace GTagSpeedMod.Mods
{
    /// <summary>
    /// Stub implementations for menu actions.
    /// These methods are placeholders to allow the project to compile
    /// without the full ii's Stupid Menu dependency set.
    /// </summary>
    public static class Fun
    {
        private static void LogStub(string name) =>
            Console.WriteLine($"[Fun Stub] {name} invoked.");

        public static void FixHead() => LogStub(nameof(FixHead));
        public static void UpsideDownHead() => LogStub(nameof(UpsideDownHead));
        public static void BrokenNeck() => LogStub(nameof(BrokenNeck));
        public static void BackwardsHead() => LogStub(nameof(BackwardsHead));
        public static void SidewaysHead() => LogStub(nameof(SidewaysHead));
        public static void HeadBang() => LogStub(nameof(HeadBang));
        public static void SpinHead(string axis) => LogStub($"{nameof(SpinHead)}:{axis}");
        public static void SpazHead(string axis) => LogStub($"{nameof(SpazHead)}:{axis}");

        public static void FlipHands() => LogStub(nameof(FlipHands));
        public static void FixHandTaps() => LogStub(nameof(FixHandTaps));
        public static void LoudHandTaps() => LogStub(nameof(LoudHandTaps));
        public static void SilentHandTaps() => LogStub(nameof(SilentHandTaps));
        public static void SilentHandTapsOnTag() => LogStub(nameof(SilentHandTapsOnTag));
        public static void WaterSplashHands() => LogStub(nameof(WaterSplashHands));
        public static void GiveWaterSplashHandsGun() => LogStub(nameof(GiveWaterSplashHandsGun));
        public static void WaterSplashAura() => LogStub(nameof(WaterSplashAura));
        public static void WaterSplashGun() => LogStub(nameof(WaterSplashGun));
        public static void WaterSplashWalk() => LogStub(nameof(WaterSplashWalk));

        public static void Freecam() => LogStub(nameof(Freecam));
        public static void DisableFreecam() => LogStub(nameof(DisableFreecam));
        public static void ThirdPersonCamera() => LogStub(nameof(ThirdPersonCamera));
        public static void FlipCamera() => LogStub(nameof(FlipCamera));
        public static void Nausea() => LogStub(nameof(Nausea));
        public static void CameraFOV() => LogStub(nameof(CameraFOV));
        public static void FixCameraFOV() => LogStub(nameof(FixCameraFOV));
        public static void SpectateGun() => LogStub(nameof(SpectateGun));

        public static void InstantParty() => LogStub(nameof(InstantParty));
        public static void OrbitWaterSplash() => LogStub(nameof(OrbitWaterSplash));
        public static void FlashColor() => LogStub(nameof(FlashColor));
        public static void StrobeColor() => LogStub(nameof(StrobeColor));
        public static void RainbowColor() => LogStub(nameof(RainbowColor));
        public static void HardRainbowColor() => LogStub(nameof(HardRainbowColor));
        public static void RainbowBracelet() => LogStub(nameof(RainbowBracelet));
        public static void RemoveRainbowBracelet() => LogStub(nameof(RemoveRainbowBracelet));
        public static void RainbowHoverboard() => LogStub(nameof(RainbowHoverboard));
        public static void StrobeHoverboard() => LogStub(nameof(StrobeHoverboard));

        public static void NoclipBuilding() => LogStub(nameof(NoclipBuilding));
        public static void DisableNoclipBuilding() => LogStub(nameof(DisableNoclipBuilding));
        public static void FastHoverboard() => LogStub(nameof(FastHoverboard));
        public static void SlowHoverboard() => LogStub(nameof(SlowHoverboard));
        public static void FixHoverboard() => LogStub(nameof(FixHoverboard));
        public static void GlobalHoverboard() => LogStub(nameof(GlobalHoverboard));
        public static void DisableGlobalHoverboard() => LogStub(nameof(DisableGlobalHoverboard));
        public static void RopeGrabReach() => LogStub(nameof(RopeGrabReach));

        public static void GrabCamera() => LogStub(nameof(GrabCamera));
        public static void GrabTablet() => LogStub(nameof(GrabTablet));
        public static void GrabGliders() => LogStub(nameof(GrabGliders));
        public static void GrabBalloons() => LogStub(nameof(GrabBalloons));
        public static void DestroyCamera() => LogStub(nameof(DestroyCamera));
        public static void DestroyTablet() => LogStub(nameof(DestroyTablet));
        public static void DestroyGliders() => LogStub(nameof(DestroyGliders));
        public static void DestroyBalloons() => LogStub(nameof(DestroyBalloons));
        public static void RespawnGliders() => LogStub(nameof(RespawnGliders));
        public static void PhysicalCamera() => LogStub(nameof(PhysicalCamera));
        public static void SpazCamera() => LogStub(nameof(SpazCamera));
        public static void SpazTablet() => LogStub(nameof(SpazTablet));
        public static void SpazGliders() => LogStub(nameof(SpazGliders));
        public static void SpazBalloons() => LogStub(nameof(SpazBalloons));
        public static void OrbitCamera() => LogStub(nameof(OrbitCamera));
        public static void OrbitTablet() => LogStub(nameof(OrbitTablet));
        public static void OrbitGliders() => LogStub(nameof(OrbitGliders));
        public static void OrbitBalloons() => LogStub(nameof(OrbitBalloons));
        public static void CameraAura() => LogStub(nameof(CameraAura));
        public static void TabletAura() => LogStub(nameof(TabletAura));
        public static void BalloonAura() => LogStub(nameof(BalloonAura));
        public static void GliderAura() => LogStub(nameof(GliderAura));
        public static void HoverboardAura() => LogStub(nameof(HoverboardAura));
        public static void BecomeCamera() => LogStub(nameof(BecomeCamera));
        public static void BecomeTablet() => LogStub(nameof(BecomeTablet));
        public static void BecomeBalloon() => LogStub(nameof(BecomeBalloon));
        public static void BecomeHoverboard() => LogStub(nameof(BecomeHoverboard));
        public static void CameraGun() => LogStub(nameof(CameraGun));
        public static void TabletGun() => LogStub(nameof(TabletGun));
        public static void GliderGun() => LogStub(nameof(GliderGun));
        public static void HoverboardGun() => LogStub(nameof(HoverboardGun));
        public static void BalloonGun() => LogStub(nameof(BalloonGun));
        public static void PopAllBalloons() => LogStub(nameof(PopAllBalloons));

        public static void CopyIdentityGun() => LogStub(nameof(CopyIdentityGun));
        public static void CopyCosmeticsGun() => LogStub(nameof(CopyCosmeticsGun));
        public static void CopyIDGun() => LogStub(nameof(CopyIDGun));
        public static void CopyIDAura() => LogStub(nameof(CopyIDAura));
        public static void CopyIDOnTouch() => LogStub(nameof(CopyIDOnTouch));
        public static void CopyIDAll() => LogStub(nameof(CopyIDAll));
        public static void CopySelfID() => LogStub(nameof(CopySelfID));
        public static void WhiteColorGun() => LogStub(nameof(WhiteColorGun));
        public static void BlackColorGun() => LogStub(nameof(BlackColorGun));
        public static void ChickenGun() => LogStub(nameof(ChickenGun));
        public static void MuteGun() => LogStub(nameof(MuteGun));
        public static void MuteAll() => LogStub(nameof(MuteAll));
        public static void UnmuteAll() => LogStub(nameof(UnmuteAll));

        public static void ChangeAccessories() => LogStub(nameof(ChangeAccessories));
        public static void SpazAccessories() => LogStub(nameof(SpazAccessories));
        public static void SpazAccessoriesBalloon() => LogStub(nameof(SpazAccessoriesBalloon));
        public static void SpazAccessoriesOthers() => LogStub(nameof(SpazAccessoriesOthers));
        public static void StickyHoldables() => LogStub(nameof(StickyHoldables));
        public static void SpazHoldables() => LogStub(nameof(SpazHoldables));
        public static void TryOnAnywhere() => LogStub(nameof(TryOnAnywhere));
        public static void TryOffAnywhere() => LogStub(nameof(TryOffAnywhere));
        public static void GetBracelet(bool enabled) => LogStub($"{nameof(GetBracelet)}:{enabled}");
        public static void RemoveBracelet() => LogStub(nameof(RemoveBracelet));
        public static void BraceletSpam() => LogStub(nameof(BraceletSpam));
        public static void GiveBuilderWatch() => LogStub(nameof(GiveBuilderWatch));
        public static void RemoveBuilderWatch() => LogStub(nameof(RemoveBuilderWatch));
        public static void AutoLoadCosmetics() => LogStub(nameof(AutoLoadCosmetics));
        public static void NoAutoLoadCosmetics() => LogStub(nameof(NoAutoLoadCosmetics));
        public static void UnlockAllCosmetics() => LogStub(nameof(UnlockAllCosmetics));

        public static void BlocksGun() => LogStub(nameof(BlocksGun));
        public static void SelectBlockGun() => LogStub(nameof(SelectBlockGun));
        public static void CopyBlockInfoGun() => LogStub(nameof(CopyBlockInfoGun));
        public static void BlockBrowser() => LogStub(nameof(BlockBrowser));
        public static void RemoveCosmeticBrowser() => LogStub(nameof(RemoveCosmeticBrowser));
        public static void SpamGrabBlocks() => LogStub(nameof(SpamGrabBlocks));
        public static void BuildingBlockMinigun() => LogStub(nameof(BuildingBlockMinigun));
        public static void DestroyBlocks() => LogStub(nameof(DestroyBlocks));
        public static void BuildingBlockAura() => LogStub(nameof(BuildingBlockAura));
        public static void BuildingBlockTextGun() => LogStub(nameof(BuildingBlockTextGun));
        public static void RainBuildingBlocks() => LogStub(nameof(RainBuildingBlocks));
        public static void BuildingBlockFountain() => LogStub(nameof(BuildingBlockFountain));
        public static void OrbitBlocks() => LogStub(nameof(OrbitBlocks));
        public static void GrabAllBlocksNearby() => LogStub(nameof(GrabAllBlocksNearby));
        public static void GrabAllSelectedNearby() => LogStub(nameof(GrabAllSelectedNearby));
        public static void UnlimitedBuilding() => LogStub(nameof(UnlimitedBuilding));
        public static void DisableUnlimitedBuilding() => LogStub(nameof(DisableUnlimitedBuilding));
        public static void PlaceBlockGun() => LogStub(nameof(PlaceBlockGun));
        public static void DestroyBlockGun() => LogStub(nameof(DestroyBlockGun));
        public static void AtticDrawGun() => LogStub(nameof(AtticDrawGun));
        public static void AtticBuildGun() => LogStub(nameof(AtticBuildGun));
        public static void AtticFreezeGun() => LogStub(nameof(AtticFreezeGun));
        public static void AtticFreezeAll() => LogStub(nameof(AtticFreezeAll));
        public static void AtticFloatGun() => LogStub(nameof(AtticFloatGun));
        public static void AtticTowerGun() => LogStub(nameof(AtticTowerGun));
        public static void MultiGrab() => LogStub(nameof(MultiGrab));
        public static void Shotgun() => LogStub(nameof(Shotgun));
        public static void MassiveBlock() => LogStub(nameof(MassiveBlock));
        public static void SaveBuilderTableData() => LogStub(nameof(SaveBuilderTableData));
        public static void LoadBuilderTableData() => LogStub(nameof(LoadBuilderTableData));

        public static void SpazSnowballs() => LogStub(nameof(SpazSnowballs));
        public static void FastSnowballs() => LogStub(nameof(FastSnowballs));
        public static void SlowSnowballs() => LogStub(nameof(SlowSnowballs));
        public static void FixSnowballs() => LogStub(nameof(FixSnowballs));
        public static void ProjectileRange() => LogStub(nameof(ProjectileRange));
        public static void SnowballButtocks() => LogStub(nameof(SnowballButtocks));
        public static void SnowballBreasts() => LogStub(nameof(SnowballBreasts));
        public static void DisableSnowballGenitals() => LogStub(nameof(DisableSnowballGenitals));
        public static void SlingshotSelf(bool enabled) => LogStub($"{nameof(SlingshotSelf)}:{enabled}");
        public static void SlingshotHelper() => LogStub(nameof(SlingshotHelper));
        public static void SlingshotTriggerBot() => LogStub(nameof(SlingshotTriggerBot));

        public static void AutoClicker() => LogStub(nameof(AutoClicker));
        public static void KeyboardTracker() => LogStub(nameof(KeyboardTracker));
        public static void DisableKeyboardTracker() => LogStub(nameof(DisableKeyboardTracker));
        public static void PreloadTagSounds() => LogStub(nameof(PreloadTagSounds));
        public static void ReportGun() => LogStub(nameof(ReportGun));
        public static void ReportAll() => LogStub(nameof(ReportAll));
        public static void TriggerAntiReportGun() => LogStub(nameof(TriggerAntiReportGun));
        public static void TriggerAntiReportAll() => LogStub(nameof(TriggerAntiReportAll));
        public static void BreakModCheckers() => LogStub(nameof(BreakModCheckers));
        public static void MuteDJSets() => LogStub(nameof(MuteDJSets));
        public static void UnmuteDJSets() => LogStub(nameof(UnmuteDJSets));
        public static void QuestNoises() => LogStub(nameof(QuestNoises));
        public static void FakeFPS() => LogStub(nameof(FakeFPS));
    }
}
