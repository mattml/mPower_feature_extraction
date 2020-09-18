get_features <- function(){
    tapFeatures <- c("meanTapInter", "medianTapInter", "iqrTapInter", "minTapInter","maxTapInter",
                     "skewTapInter", "kurTapInter",  "sdTapInter", "madTapInter","cvTapInter",
                     "rangeTapInter", "tkeoTapInter",  "ar1TapInter",  "ar2TapInter","fatigue10TapInter",
                     "fatigue25TapInter", "fatigue50TapInter", "meanDriftLeft","medianDriftLeft",  "iqrDriftLeft",
                     "minDriftLeft", "maxDriftLeft", "skewDriftLeft",  "kurDriftLeft", "sdDriftLeft",
                     "madDriftLeft", "cvDriftLeft",  "rangeDriftLeft", "meanDriftRight", "medianDriftRight",
                     "iqrDriftRight", "minDriftRight", "maxDriftRight",  "skewDriftRight", "kurDriftRight",
                     "sdDriftRight", "madDriftRight",  "cvDriftRight",  "rangeDriftRight", "numberTaps",
                     "buttonNoneFreq")

    walkFeatures <- c('meanX', 'sdX', 'modeX', 'skewX', 'kurX', 'q1X', 'medianX', 'q3X',
                      'iqrX', 'rangeX', 'acfX', 'zcrX', 'dfaX', 'cvX', 'tkeoX', 'F0X',
                      'P0X', 'F0FX', 'P0FX', 'medianF0FX', 'sdF0FX', 'tlagX', 'meanY',
                      'sdY', 'modeY', 'skewY', 'kurY', 'q1Y', 'medianY', 'q3Y', 'iqrY',
                      'rangeY', 'acfY', 'zcrY', 'dfaY', 'cvY', 'tkeoY', 'F0Y', 'P0Y', 'F0FY',
                      'P0FY', 'medianF0FY', 'sdF0FY', 'tlagY', 'meanZ', 'sdZ', 'modeZ', 'skewZ',
                      'kurZ', 'q1Z', 'medianZ', 'q3Z', 'iqrZ', 'rangeZ', 'acfZ', 'zcrZ', 'dfaZ', 'cvZ',
                      'tkeoZ', 'F0Z', 'P0Z', 'F0FZ', 'P0FZ', 'medianF0FZ', 'sdF0FZ', 'tlagZ', 'meanAA',
                      'sdAA', 'modeAA', 'skewAA', 'kurAA', 'q1AA', 'medianAA', 'q3AA', 'iqrAA', 'rangeAA',
                      'acfAA', 'zcrAA', 'dfaAA', 'cvAA', 'tkeoAA', 'F0AA', 'P0AA', 'F0FAA', 'P0FAA',
                      'medianF0FAA', 'sdF0FAA', 'tlagAA', 'meanAJ', 'sdAJ', 'modeAJ', 'skewAJ', 'kurAJ', 'q1AJ',
                      'medianAJ', 'q3AJ', 'iqrAJ', 'rangeAJ', 'acfAJ', 'zcrAJ', 'dfaAJ', 'cvAJ', 'tkeoAJ', 'F0AJ',
                      'P0AJ', 'F0FAJ', 'P0FAJ', 'medianF0FAJ', 'sdF0FAJ', 'tlagAJ', 'corXY', 'corXZ', 'corYZ')

    restFeatures <- c('meanAA', 'sdAA', 'modeAA', 'skewAA', 'kurAA', 'q1AA', 'medianAA',
                      'q3AA', 'iqrAA', 'rangeAA', 'acfAA', 'zcrAA', 'dfaAA', 'turningTime',
                      'postpeak', 'postpower', 'alpha', 'dVol', 'ddVol')

    voiceFeatures <- c('Median_F0', 'Mean_Jitter', 'Median_Jitter', 'Mean_Shimmer', 'Median_Shimmer',
                       'MFCC_Band_1', 'MFCC_Band_2', 'MFCC_Band_3', 'MFCC_Band_4', 'MFCC_Jitter_Band_1_Positive',
                       'MFCC_Jitter_Band_2_Positive', 'MFCC_Jitter_Band_3_Positive', 'MFCC_Jitter_Band_4_Positive')

    return(list(tap = tapFeatures,
                walk = walkFeatures,
                rest = restFeatures,
                voice = voiceFeatures))
}
