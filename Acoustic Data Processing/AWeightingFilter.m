function ASPL = AWeightingFilter(SPL)

Afilt = WeightingFilter('A-weighting',48000);
ASPL = Afilt(SPL);


