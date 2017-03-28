#define ACRE_SQUAWK(squawkName, squawkPath) class DOUBLES(squawkName,10) \ { \
                                                name = #squawkName; \
                                                sound[] = {squawkPath, 1, 1}; \
                                                titles[] = {}; \
                                            }; \
                                            class DOUBLES(squawkName,9): DOUBLES(squawkName,10) { sound[] = {squawkPath, 0.9, 1}; }; \
                                            class DOUBLES(squawkName,8): DOUBLES(squawkName,10) { sound[] = {squawkPath, 0.8, 1}; }; \
                                            class DOUBLES(squawkName,7): DOUBLES(squawkName,10) { sound[] = {squawkPath, 0.7, 1}; }; \
                                            class DOUBLES(squawkName,6): DOUBLES(squawkName,10) { sound[] = {squawkPath, 0.6, 1}; }; \
                                            class DOUBLES(squawkName,5): DOUBLES(squawkName,10) { sound[] = {squawkPath, 0.5, 1}; }; \
                                            class DOUBLES(squawkName,4): DOUBLES(squawkName,10) { sound[] = {squawkPath, 0.4, 1}; }; \
                                            class DOUBLES(squawkName,3): DOUBLES(squawkName,10) { sound[] = {squawkPath, 0.3, 1}; }; \
                                            class DOUBLES(squawkName,2): DOUBLES(squawkName,10) { sound[] = {squawkPath, 0.2, 1}; }; \
                                            class DOUBLES(squawkName,1): DOUBLES(squawkName,10) { sound[] = {squawkPath, 0.1, 1}; }

#define RADIO_WEAPON_LIST_STR(CLASSNAME)    QUOTE(CLASSNAME),                    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_1)),        \
                                            QUOTE(DOUBLES(CLASSNAME,ID_2)),        \
                                            QUOTE(DOUBLES(CLASSNAME,ID_3)),        \
                                            QUOTE(DOUBLES(CLASSNAME,ID_4)),        \
                                            QUOTE(DOUBLES(CLASSNAME,ID_5)),        \
                                            QUOTE(DOUBLES(CLASSNAME,ID_6)),        \
                                            QUOTE(DOUBLES(CLASSNAME,ID_7)),        \
                                            QUOTE(DOUBLES(CLASSNAME,ID_8)),        \
                                            QUOTE(DOUBLES(CLASSNAME,ID_9)),        \
                                            QUOTE(DOUBLES(CLASSNAME,ID_10)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_11)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_12)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_13)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_14)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_15)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_16)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_17)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_18)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_19)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_20)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_21)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_22)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_23)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_24)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_25)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_26)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_27)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_28)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_29)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_30)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_31)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_32)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_33)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_34)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_35)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_36)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_37)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_38)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_39)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_40)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_41)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_42)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_43)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_44)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_45)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_46)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_47)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_48)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_49)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_50)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_51)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_52)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_53)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_54)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_55)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_56)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_57)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_58)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_59)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_60)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_61)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_62)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_63)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_64)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_65)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_66)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_67)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_68)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_69)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_70)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_71)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_72)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_73)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_74)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_75)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_76)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_77)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_78)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_79)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_80)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_81)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_82)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_83)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_84)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_85)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_86)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_87)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_88)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_89)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_90)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_91)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_92)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_93)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_94)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_95)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_96)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_97)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_98)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_99)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_100)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_101)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_102)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_103)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_104)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_105)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_106)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_107)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_108)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_109)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_110)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_111)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_112)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_113)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_114)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_115)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_116)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_117)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_118)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_119)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_120)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_121)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_122)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_123)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_124)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_125)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_126)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_127)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_128)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_129)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_130)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_131)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_132)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_133)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_134)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_135)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_136)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_137)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_138)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_139)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_140)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_141)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_142)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_143)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_144)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_145)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_146)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_147)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_148)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_149)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_150)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_151)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_152)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_153)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_154)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_155)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_156)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_157)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_158)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_159)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_160)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_161)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_162)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_163)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_164)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_165)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_166)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_167)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_168)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_169)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_170)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_171)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_172)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_173)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_174)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_175)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_176)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_177)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_178)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_179)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_180)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_181)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_182)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_183)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_184)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_185)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_186)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_187)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_188)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_189)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_190)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_191)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_192)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_193)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_194)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_195)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_196)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_197)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_198)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_199)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_200)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_201)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_202)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_203)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_204)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_205)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_206)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_207)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_208)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_209)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_210)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_211)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_212)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_213)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_214)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_215)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_216)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_217)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_218)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_219)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_220)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_221)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_222)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_223)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_224)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_225)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_226)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_227)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_228)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_229)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_230)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_231)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_232)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_233)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_234)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_235)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_236)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_237)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_238)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_239)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_240)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_241)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_242)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_243)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_244)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_245)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_246)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_247)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_248)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_249)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_250)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_251)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_252)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_253)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_254)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_255)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_256)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_257)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_258)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_259)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_260)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_261)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_262)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_263)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_264)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_265)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_266)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_267)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_268)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_269)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_270)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_271)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_272)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_273)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_274)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_275)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_276)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_277)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_278)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_279)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_280)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_281)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_282)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_283)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_284)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_285)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_286)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_287)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_288)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_289)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_290)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_291)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_292)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_293)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_294)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_295)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_296)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_297)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_298)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_299)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_300)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_301)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_302)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_303)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_304)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_305)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_306)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_307)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_308)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_309)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_310)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_311)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_312)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_313)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_314)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_315)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_316)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_317)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_318)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_319)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_320)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_321)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_322)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_323)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_324)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_325)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_326)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_327)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_328)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_329)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_330)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_331)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_332)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_333)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_334)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_335)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_336)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_337)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_338)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_339)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_340)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_341)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_342)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_343)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_344)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_345)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_346)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_347)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_348)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_349)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_350)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_351)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_352)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_353)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_354)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_355)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_356)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_357)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_358)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_359)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_360)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_361)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_362)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_363)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_364)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_365)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_366)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_367)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_368)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_369)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_370)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_371)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_372)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_373)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_374)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_375)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_376)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_377)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_378)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_379)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_380)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_381)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_382)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_383)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_384)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_385)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_386)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_387)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_388)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_389)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_390)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_391)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_392)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_393)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_394)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_395)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_396)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_397)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_398)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_399)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_400)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_401)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_402)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_403)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_404)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_405)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_406)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_407)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_408)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_409)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_410)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_411)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_412)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_413)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_414)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_415)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_416)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_417)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_418)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_419)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_420)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_421)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_422)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_423)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_424)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_425)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_426)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_427)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_428)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_429)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_430)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_431)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_432)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_433)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_434)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_435)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_436)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_437)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_438)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_439)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_440)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_441)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_442)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_443)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_444)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_445)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_446)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_447)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_448)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_449)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_450)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_451)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_452)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_453)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_454)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_455)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_456)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_457)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_458)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_459)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_460)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_461)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_462)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_463)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_464)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_465)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_466)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_467)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_468)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_469)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_470)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_471)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_472)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_473)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_474)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_475)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_476)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_477)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_478)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_479)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_480)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_481)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_482)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_483)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_484)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_485)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_486)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_487)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_488)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_489)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_490)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_491)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_492)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_493)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_494)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_495)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_496)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_497)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_498)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_499)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_500)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_501)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_502)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_503)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_504)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_505)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_506)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_507)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_508)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_509)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_510)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_511)),    \
                                            QUOTE(DOUBLES(CLASSNAME,ID_512))


#define RADIO_ID_UNIQUEENTRY(CLASSNAME, ID)    acre_hasUnique = 0; acre_isUnique = 1; acre_baseClass = QUOTE(CLASSNAME); acre_uniqueId = ID; scope = 1; scopeCurator = 0; class Armory { disabled = 1; };

#define RADIO_ID_LIST(CLASSNAME)    class DOUBLES(CLASSNAME,ID_1): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 1) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_2): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 2) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_3): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 3) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_4): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 4) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_5): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 5) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_6): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 6) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_7): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 7) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_8): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 8) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_9): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 9) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_10): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 10) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_11): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 11) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_12): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 12) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_13): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 13) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_14): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 14) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_15): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 15) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_16): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 16) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_17): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 17) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_18): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 18) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_19): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 19) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_20): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 20) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_21): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 21) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_22): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 22) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_23): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 23) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_24): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 24) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_25): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 25) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_26): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 26) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_27): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 27) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_28): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 28) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_29): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 29) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_30): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 30) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_31): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 31) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_32): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 32) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_33): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 33) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_34): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 34) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_35): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 35) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_36): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 36) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_37): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 37) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_38): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 38) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_39): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 39) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_40): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 40) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_41): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 41) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_42): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 42) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_43): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 43) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_44): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 44) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_45): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 45) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_46): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 46) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_47): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 47) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_48): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 48) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_49): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 49) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_50): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 50) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_51): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 51) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_52): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 52) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_53): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 53) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_54): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 54) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_55): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 55) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_56): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 56) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_57): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 57) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_58): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 58) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_59): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 59) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_60): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 60) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_61): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 61) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_62): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 62) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_63): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 63) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_64): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 64) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_65): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 65) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_66): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 66) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_67): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 67) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_68): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 68) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_69): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 69) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_70): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 70) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_71): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 71) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_72): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 72) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_73): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 73) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_74): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 74) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_75): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 75) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_76): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 76) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_77): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 77) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_78): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 78) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_79): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 79) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_80): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 80) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_81): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 81) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_82): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 82) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_83): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 83) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_84): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 84) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_85): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 85) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_86): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 86) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_87): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 87) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_88): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 88) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_89): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 89) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_90): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 90) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_91): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 91) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_92): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 92) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_93): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 93) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_94): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 94) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_95): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 95) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_96): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 96) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_97): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 97) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_98): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 98) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_99): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 99) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_100): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 100) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_101): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 101) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_102): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 102) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_103): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 103) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_104): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 104) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_105): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 105) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_106): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 106) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_107): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 107) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_108): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 108) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_109): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 109) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_110): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 110) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_111): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 111) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_112): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 112) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_113): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 113) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_114): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 114) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_115): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 115) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_116): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 116) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_117): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 117) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_118): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 118) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_119): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 119) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_120): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 120) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_121): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 121) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_122): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 122) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_123): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 123) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_124): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 124) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_125): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 125) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_126): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 126) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_127): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 127) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_128): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 128) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_129): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 129) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_130): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 130) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_131): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 131) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_132): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 132) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_133): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 133) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_134): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 134) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_135): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 135) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_136): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 136) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_137): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 137) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_138): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 138) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_139): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 139) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_140): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 140) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_141): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 141) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_142): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 142) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_143): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 143) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_144): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 144) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_145): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 145) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_146): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 146) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_147): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 147) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_148): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 148) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_149): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 149) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_150): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 150) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_151): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 151) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_152): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 152) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_153): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 153) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_154): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 154) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_155): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 155) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_156): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 156) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_157): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 157) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_158): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 158) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_159): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 159) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_160): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 160) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_161): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 161) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_162): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 162) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_163): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 163) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_164): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 164) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_165): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 165) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_166): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 166) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_167): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 167) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_168): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 168) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_169): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 169) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_170): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 170) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_171): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 171) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_172): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 172) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_173): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 173) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_174): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 174) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_175): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 175) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_176): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 176) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_177): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 177) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_178): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 178) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_179): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 179) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_180): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 180) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_181): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 181) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_182): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 182) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_183): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 183) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_184): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 184) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_185): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 185) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_186): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 186) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_187): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 187) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_188): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 188) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_189): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 189) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_190): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 190) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_191): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 191) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_192): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 192) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_193): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 193) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_194): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 194) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_195): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 195) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_196): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 196) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_197): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 197) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_198): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 198) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_199): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 199) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_200): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 200) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_201): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 201) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_202): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 202) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_203): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 203) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_204): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 204) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_205): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 205) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_206): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 206) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_207): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 207) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_208): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 208) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_209): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 209) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_210): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 210) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_211): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 211) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_212): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 212) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_213): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 213) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_214): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 214) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_215): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 215) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_216): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 216) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_217): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 217) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_218): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 218) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_219): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 219) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_220): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 220) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_221): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 221) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_222): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 222) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_223): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 223) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_224): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 224) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_225): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 225) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_226): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 226) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_227): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 227) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_228): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 228) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_229): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 229) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_230): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 230) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_231): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 231) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_232): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 232) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_233): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 233) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_234): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 234) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_235): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 235) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_236): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 236) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_237): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 237) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_238): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 238) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_239): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 239) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_240): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 240) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_241): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 241) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_242): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 242) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_243): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 243) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_244): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 244) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_245): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 245) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_246): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 246) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_247): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 247) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_248): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 248) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_249): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 249) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_250): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 250) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_251): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 251) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_252): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 252) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_253): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 253) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_254): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 254) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_255): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 255) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_256): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 256) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_257): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 257) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_258): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 258) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_259): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 259) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_260): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 260) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_261): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 261) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_262): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 262) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_263): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 263) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_264): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 264) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_265): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 265) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_266): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 266) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_267): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 267) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_268): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 268) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_269): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 269) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_270): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 270) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_271): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 271) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_272): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 272) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_273): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 273) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_274): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 274) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_275): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 275) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_276): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 276) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_277): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 277) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_278): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 278) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_279): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 279) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_280): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 280) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_281): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 281) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_282): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 282) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_283): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 283) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_284): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 284) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_285): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 285) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_286): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 286) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_287): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 287) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_288): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 288) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_289): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 289) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_290): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 290) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_291): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 291) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_292): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 292) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_293): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 293) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_294): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 294) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_295): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 295) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_296): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 296) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_297): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 297) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_298): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 298) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_299): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 299) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_300): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 300) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_301): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 301) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_302): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 302) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_303): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 303) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_304): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 304) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_305): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 305) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_306): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 306) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_307): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 307) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_308): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 308) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_309): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 309) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_310): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 310) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_311): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 311) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_312): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 312) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_313): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 313) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_314): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 314) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_315): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 315) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_316): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 316) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_317): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 317) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_318): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 318) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_319): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 319) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_320): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 320) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_321): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 321) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_322): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 322) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_323): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 323) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_324): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 324) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_325): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 325) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_326): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 326) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_327): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 327) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_328): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 328) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_329): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 329) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_330): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 330) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_331): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 331) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_332): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 332) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_333): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 333) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_334): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 334) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_335): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 335) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_336): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 336) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_337): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 337) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_338): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 338) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_339): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 339) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_340): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 340) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_341): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 341) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_342): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 342) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_343): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 343) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_344): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 344) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_345): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 345) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_346): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 346) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_347): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 347) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_348): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 348) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_349): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 349) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_350): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 350) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_351): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 351) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_352): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 352) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_353): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 353) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_354): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 354) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_355): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 355) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_356): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 356) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_357): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 357) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_358): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 358) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_359): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 359) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_360): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 360) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_361): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 361) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_362): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 362) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_363): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 363) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_364): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 364) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_365): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 365) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_366): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 366) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_367): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 367) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_368): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 368) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_369): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 369) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_370): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 370) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_371): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 371) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_372): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 372) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_373): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 373) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_374): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 374) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_375): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 375) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_376): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 376) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_377): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 377) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_378): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 378) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_379): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 379) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_380): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 380) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_381): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 381) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_382): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 382) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_383): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 383) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_384): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 384) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_385): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 385) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_386): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 386) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_387): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 387) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_388): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 388) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_389): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 389) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_390): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 390) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_391): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 391) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_392): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 392) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_393): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 393) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_394): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 394) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_395): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 395) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_396): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 396) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_397): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 397) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_398): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 398) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_399): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 399) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_400): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 400) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_401): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 401) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_402): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 402) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_403): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 403) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_404): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 404) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_405): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 405) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_406): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 406) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_407): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 407) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_408): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 408) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_409): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 409) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_410): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 410) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_411): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 411) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_412): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 412) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_413): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 413) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_414): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 414) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_415): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 415) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_416): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 416) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_417): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 417) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_418): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 418) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_419): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 419) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_420): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 420) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_421): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 421) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_422): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 422) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_423): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 423) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_424): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 424) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_425): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 425) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_426): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 426) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_427): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 427) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_428): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 428) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_429): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 429) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_430): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 430) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_431): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 431) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_432): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 432) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_433): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 433) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_434): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 434) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_435): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 435) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_436): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 436) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_437): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 437) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_438): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 438) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_439): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 439) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_440): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 440) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_441): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 441) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_442): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 442) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_443): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 443) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_444): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 444) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_445): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 445) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_446): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 446) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_447): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 447) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_448): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 448) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_449): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 449) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_450): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 450) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_451): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 451) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_452): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 452) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_453): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 453) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_454): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 454) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_455): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 455) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_456): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 456) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_457): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 457) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_458): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 458) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_459): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 459) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_460): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 460) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_461): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 461) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_462): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 462) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_463): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 463) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_464): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 464) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_465): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 465) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_466): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 466) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_467): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 467) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_468): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 468) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_469): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 469) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_470): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 470) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_471): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 471) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_472): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 472) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_473): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 473) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_474): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 474) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_475): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 475) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_476): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 476) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_477): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 477) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_478): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 478) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_479): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 479) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_480): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 480) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_481): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 481) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_482): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 482) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_483): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 483) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_484): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 484) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_485): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 485) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_486): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 486) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_487): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 487) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_488): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 488) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_489): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 489) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_490): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 490) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_491): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 491) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_492): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 492) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_493): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 493) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_494): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 494) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_495): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 495) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_496): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 496) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_497): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 497) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_498): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 498) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_499): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 499) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_500): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 500) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_501): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 501) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_502): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 502) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_503): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 503) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_504): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 504) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_505): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 505) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_506): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 506) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_507): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 507) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_508): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 508) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_509): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 509) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_510): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 510) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_511): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 511) \
                                    };\
                                    class DOUBLES(CLASSNAME,ID_512): CLASSNAME {\
                                        RADIO_ID_UNIQUEENTRY(CLASSNAME, 512) \
                                    };
