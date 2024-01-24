'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "7c40abc62429087a328ee3d4edf4b01b",
".git/config": "3ea822c20062ed2f47853759b6c31c85",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "baea8aa9bc2eca221683d87653f14802",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "e5fc5cf659767bf3458fc2ce916b36e1",
".git/logs/refs/heads/gh-pages": "c6e90aa4ecdae03ca2c434aca7d0d7bf",
".git/logs/refs/heads/master": "dba5bbc0194c129cb7e0babc13bbdc47",
".git/objects/01/c4ed02152a422ec2b0b2fb471ed2e0f2ff2aa3": "0b25dec55ce24a9df3b72e9d89cd57d2",
".git/objects/04/e5efc15dc0c60ea2ffcc37c5bf25e96689f44d": "978222f47488835b92838c74cb5c684c",
".git/objects/04/fd879d9a263cfea3be1b2964d53be70515d96d": "8423b0167e8c44b020ad4512d3edcc32",
".git/objects/0a/4dc1ff50658fd02c157e68daa838c0697a06cb": "9586d1300af427d7a6f837691674662a",
".git/objects/0c/dbb4fc4476ed08baf179d33f43fae1e51e7cc5": "d47fe7a618b054797a60fb3253a26c1e",
".git/objects/0d/846c8d4e47a645a373889c8b2c499152924140": "7f8f3bbf2e35701a64b33210abfe6443",
".git/objects/0e/3a67fee3f816ecf49140eb778800822f868071": "e6f6e8770a80123588ecaed644d7c63d",
".git/objects/0e/e3590f4d74c3a4e4621a8d048d01f13436ec7a": "25939fd9f3cb53628d90cf3f4f9a026a",
".git/objects/11/2d3a41f580af7b5ac32062d3e9af9661800eee": "4c1a2d5464a0711e09ac21e02ba3256b",
".git/objects/12/ca480aafe5a67b2e888644c6c0160630320753": "b4f6f07de749c7454280b9803aeeccd6",
".git/objects/15/0ac57c0e8b66abb9ab58da80f10002705d710c": "1ef10e623d832da811a6a42482c3a867",
".git/objects/15/273e50f105a5737df55844a81aea31525a79b3": "4e43cc2ffa9aac505a3fdbedd6faacf2",
".git/objects/18/91f2c0069ced09c8627a2f13d4292ecd39292b": "69b0d87757e989b519275a344d171b94",
".git/objects/19/20af1e526a255ee2c70c5c4fe6eca54e768f0e": "eba684fae2f6d88d01f1c37af7c7d306",
".git/objects/1b/3e753dd2d93c7f7e7692a55d2acfc5df5a250f": "cad82f87987528237c08f9d1d7ad07de",
".git/objects/1e/74f1496571f1fe71a8070178dbd78b1671d268": "c2fdf6871991ca7e48b8d93edb5534d2",
".git/objects/1e/b55e723637ffb2c40590ae0ac3019754b41ba6": "2541088f69fd4b433d4f8c39b95c172f",
".git/objects/20/1afe538261bd7f9a38bed0524669398070d046": "82a4d6c731c1d8cdc48bce3ab3c11172",
".git/objects/20/1cc58b85387a7c15ca41662393dbd53e9c600f": "0250a4f0eb6d058379358ed628505414",
".git/objects/21/565f8716f0307fe118ad8cf3fee2de904abad1": "2841aba185673c553436bba0643d8a50",
".git/objects/22/425af0866d5778bba5259e021c8a9ed7a98652": "e352683e6487062f008acc874aa47380",
".git/objects/23/79648d5cb5ed8a35b47c71074937181ea0720c": "ca1b96f4b0408e52e4b62affe8186cb0",
".git/objects/2b/6392ffe8712b9c5450733320cd220d6c0f4bce": "8c5765aae9760c295ac45acfb0e04a63",
".git/objects/2b/e39c7fd3da441ddac9bea54fd12621dd39960a": "24031b20667d22ca8dba4debe8b9eab5",
".git/objects/2b/e8b589a907263ea0ea6c747e5653b7906e6310": "fb341e73d47d23ba4dc218b5af827605",
".git/objects/2d/3d8ba5ba03eb50266044f8984130475cdddae8": "96de77a09180b58abba8cd7b15e1b1c0",
".git/objects/2d/a5e5478cb296fccce6e6556286175d600bed8b": "90fb351857b5c4e70389bab4a151f30f",
".git/objects/2d/bd3dcd789fa37d6f723f0876e56443eee0438e": "78df6a31ab95f94116432437797b84c6",
".git/objects/2f/886ea41fc94bdba17b25f3ea76918403e94bfc": "4d3ae975f4690869f9186510cf71a3bf",
".git/objects/30/e88be440aa29caf908c8558df774904641c21e": "15b9b5a100c23b871d2cbf5d93485b5b",
".git/objects/34/2fc5f5d557bb479a2c2862706cb4b77dc83369": "4e6206f4105758c7ee26e9263153715b",
".git/objects/36/b09d6044c743e8429075a9cbbceb81e04964f6": "649613fe620e1f1b30d0b73a81a1d103",
".git/objects/38/cff5a0975d39b03db14a406fba8c4e37ce5e3b": "961c2aea8ac45dafd60717972d608436",
".git/objects/39/e6f8f79e04ad5df8d5a10ec732f51b6580259a": "e6be3eeab4ead62714d578a59f336505",
".git/objects/3a/7795ce82e55d8f9c99e7beaa0c85141f8d2835": "8a5558c663d87709cb2353c1b35642f0",
".git/objects/3c/46c59696051488cca44e3f65710a33ee296808": "ec1d365eb9b009b4567a87cd2ec28f00",
".git/objects/3d/17220ba8611f1a978d37fc809c3015452018f7": "6168d9d74a744d3c8f9cc494d0124a66",
".git/objects/3d/89330c954a3882fd0266dcd5e2bf44e6331833": "d9c138ce8d0e99397775f683e87a75cb",
".git/objects/42/5d41ce4fe13f6a9a22711ff7a18dca5449187e": "738d42f3151356a4779e378c55425bd0",
".git/objects/43/e946e398d96aee466fa0aabb625f0889c3a4bd": "ac34520dee747f675e6e0a15c0bbd2be",
".git/objects/45/992c3680e710b8d244112b969000d1e7e884e6": "611271e0a3796227b377b8de89dce966",
".git/objects/45/a1cb7e786bfd7fa88dd6d6e2180d9d35724271": "34fc08d6957d18998c1cb519987f789d",
".git/objects/48/33fcf9ba677d3df448c90e63368e50f8bfc8d6": "a5b926fccf641f8e2a09e52478c0d37a",
".git/objects/4b/825dc642cb6eb9a060e54bf8d69288fbee4904": "75589287973d2772c2fc69d664e10822",
".git/objects/4b/c4e1dd720056e0382fdbc646a1535db27efaa7": "1d7f85527634b241d008bd689fe85449",
".git/objects/4d/a77408c5a6cb9277a6e49cf0d7e7bb2252f46e": "b9f2fee1bd1178d363302ab849aa915b",
".git/objects/4e/0ec4ce9f65a799729ea18a82a64166190d9c1e": "ad934ad180c8eedd3389348e0745614f",
".git/objects/4f/d0e51f345ee398d4c56c9a2a36514cfdc54f3e": "d8e976b7b97437231f01681fc40815a3",
".git/objects/50/13b4ca1650d937c7f03e76cc8e025058e59710": "044684d2a45b20a848ff16f56a7a3122",
".git/objects/52/e1b36ef8268f39631293261a50d265409e813f": "864ff7f369dc70df2527c6eeb097b670",
".git/objects/53/7807567919e88db2866b7825339c57e94c24d8": "970aec5149a3dbe9370a9dc982cdd022",
".git/objects/53/e2c1b9273a28f66d20cf7885da860a797e53e8": "58bb14b3e291de761e72e49cce7da1ab",
".git/objects/54/4e340a0aa250b466b7344ee96220d12aaf2bdb": "12bf3ff23c8f006271d39a634b9eee90",
".git/objects/55/099e822b86c848fc2f9ebf038e88c37f240fc5": "db88dba498015f73b9b3d2f99f769667",
".git/objects/5a/b808a706e205e1a53f8da525c39a2d751d4976": "890e8e666543e0e49abeb718ee5c20d7",
".git/objects/5b/147b42e6ef4a8b6e98769f5a750a8001626e81": "ffcba4861561d9ba29937d8c1aece778",
".git/objects/5b/96c4626dc920791e457386a52294e4f8a10e69": "ae4d905816ee74c34900b00521251a93",
".git/objects/5d/a2d66aa16ac070301c1bbe53408b8543cddc47": "7f0f51d4ea6938deb96c146c2689ee2a",
".git/objects/5f/09d99c85d8b65669d2baa662c852fbe6876b93": "07c51b06faebbafb2c5af6703b84d2a7",
".git/objects/61/6b3d04c99373c9d132bee2d8db5612bc0d53f0": "b3404aca0234e5190e5c1066e92bfe9d",
".git/objects/63/c544697415005b82d373b9769abc83108e654f": "17bd131f2e5ffa132fd4644fea668a29",
".git/objects/65/c32c4db5a09ee86c444b428996eb77e709d8b8": "a303f2d4adae189999eea91247af8be4",
".git/objects/66/85384533ea9db0f279e1089ad6aae5ec65aa45": "2bacae24c2d7109e968a35aa33d9f284",
".git/objects/68/a2ec3753591d76aeb866158f69b9968bc523ee": "bf184fd68dfef0779919016a286fe07c",
".git/objects/6c/c57dcc202d41eecbcc5290d6651ccbabd34849": "fec61b554a9700755d13b9e099375204",
".git/objects/6e/06f851ffd2c81f58ad2ec2d091ea9d6051b817": "7d3e4bedc0748066252e21b88fb77a4e",
".git/objects/70/3317a271b80e112aa3edd960fcb49a07c1b369": "aeb95dfebad6dab3508f7557b821168d",
".git/objects/70/89e3e5a47a6d2430351bc235150fd10af2c743": "e44757f5389f0c5cc8c73edbffe8a4ca",
".git/objects/72/bd2ed7fd3da448ff535261c512c784ee9b433e": "db3348cba4af3dfbf53bb80bda689567",
".git/objects/73/93949f5569c6705a062e11c0e11d0e900c6318": "ae3d01e858b4e939dc0e5360eb89e556",
".git/objects/76/4471243f85f0cceddb5ceb55635d2cbf765b26": "36d6f20490635d2c5523cf1c403fcbdc",
".git/objects/79/9fe981d03d8d224bdc5ddb6c51d76f6254824b": "bfb65597fbb450afaef520b774f8721e",
".git/objects/7c/acb429184973d35f15e80736b0f1996aa23749": "4f6d40f42c358c5bce2336c6a1a59e60",
".git/objects/7d/4bcf0fa9122011e1e697e4e2756effc42b4f88": "04ad261e50ad94d4401abace4a5abcf0",
".git/objects/7e/67c117ca8c6e5fdc6bb4ac1470c62ea43b2092": "62c2b7c4134ed629b89d9e975c6219f7",
".git/objects/87/27c10f0edd0a853330e1f3564f00f2da6bd21b": "821a766466dfa715f85fb191f6bfc6e4",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/54d609d8cb51dde005eeb37cf08230783b9973": "c464d45b5938fef180bf0e5ebb2d5479",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8f/25e8d919cef0760d273cb7735090a8eab7d4da": "f2f21b9d8f9bc95366e041161de7a45a",
".git/objects/94/b52e13bf7919ae4ea7235d78019b592dde8611": "b79fa5ca1cdbf72f253763797850f314",
".git/objects/96/563ef639fb9000f8d237b61933723339e12eed": "6a9c28edd78d942e30ab7e02acd8ebb0",
".git/objects/97/d8c2a488e506746d198eea4e6c62f46ba3bb69": "8add19f14cceded01df2f1514211cc15",
".git/objects/98/9f323b1e32b3522c404c91818fb9b67a5e76c0": "40621651a2d95c3406fd94d623dfce09",
".git/objects/9a/ca5187dffc678e0e486fe5b36876ec419b90a1": "cf3368453a9e5ff4ffa9cb1adfed915f",
".git/objects/9c/26b00c0d43fe5fbfb7fc69d5e1d24091d3315a": "93263b38e4d9bc66c34612bdea966d60",
".git/objects/9c/7c158b408678b73058577ff24d2f3afd0f7855": "2400be691e91dda243c34b670efb5836",
".git/objects/9f/46bb964af7d8c41a134391edb52ffe8753b078": "a0cbe4b89871c9a19495997dc3e45e1f",
".git/objects/a0/640029025dd7670b1a009c9414662db175a6cd": "3c758a3fbbf5cadcafc827c37d5589a9",
".git/objects/a5/6514c952f03efd5505ab567253508bcb5ffc03": "003858c3a43ffe76057508681c74fb37",
".git/objects/a6/028aaa8f29de5dc67448b70853a7b34e40906e": "21f52d40aaab5b7144ea409b5ff99886",
".git/objects/a7/5323178e665ba24474291352cf8d33c29d8ecd": "10e489a2798f04ae767f953930986502",
".git/objects/ac/654bd43ea85002de0482a8ae222c60eeccacd7": "d3a4ab78e0adc08788af2a7a1e28997b",
".git/objects/ae/8718be31c28331c02e880e9ee625ab51f4b0f2": "65334590c5b142a0776c18e7ca6af310",
".git/objects/b2/6ace6f6a350b93991637c29b64116ded60f34e": "40f3432124a7e5ab17d22c15cb87b2a3",
".git/objects/b6/dda93ff32ab715fc53ddb71302d5744364a68c": "e76890df2fae4b91f70a7203ba1cb024",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b8/ff96edab0a538651a36ce7e9a53fe36f437793": "391796950291c213e7e4ca192e4744ce",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/a4679d5efbf33e3ea021b1958d1ec0ec014ca8": "0643f6fa297477ba79a9e460212939bb",
".git/objects/ba/8cb00dd5231f1a55de0205c16445926a696526": "be8592f9341c9b01b70890c8614c6cf7",
".git/objects/bb/3085876799532613a08c7ebe43f24f0cc46864": "1b6aa21800d948d5513c15e54d131215",
".git/objects/bb/bde1eeaff1f330042cf9b1310379dcbc0ee093": "afdcdb7a23169a911e7e1852f346e896",
".git/objects/bd/bd8f2bfd9eb785c26f2d0278201dc740f63f81": "5a86c1254c829d46b3316736c0b4d744",
".git/objects/bf/c74396185cf1afac1fd201678ebcdf9386f8c2": "0ebf706a05c2d3ab84d6beda0dc32c19",
".git/objects/c0/07474d27daf51e81a4e7cd1b3a7c0423396e05": "c8eff140951e0da1a2f835ccb10647a4",
".git/objects/c3/51f7deeda468257dfdb45ae308726dcbc28042": "19890c75a8ba27275c57431bd95e370e",
".git/objects/c6/31a799822a3d06b72af75f7ec11024c2efcce0": "fe9a018bc22fa9e708e6fbb78a0df4a9",
".git/objects/c8/da8aba53bc600d15c7a712994f15c7c3e1dd55": "3fd4d42060b51f6bd882675dcc47b34e",
".git/objects/cc/a0514872e52e9ac6d1973df9d4cef5a10475bc": "d5e3c295501bb466e7b13a10194815c2",
".git/objects/ce/8fe08de32223fe0dbb3f43d80be7e5dc6abbac": "4bbed5eacb68e58f48b7837357298b2e",
".git/objects/d3/89eea155ac630709b3bb76f19f279f023ecac0": "47bd7795bca7ef85756023dc7d301c29",
".git/objects/d6/11193c9b7c29e2d71702d96a5e094baa1f8bb4": "862960b042c42c9df5a8787870059928",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d7/2c11112c7cb4e2ce754bc41470f9b829a2d00a": "d7280a766a5d6033f187d874a92b5ad6",
".git/objects/d7/66a85a277d5501dcbd3981006b4901678c5fdf": "a3fed2fa1302d9c907abdfd8d85b4650",
".git/objects/d9/98cf5b468413ca1c950096dc9d0f5dfdb1359f": "872d06090d2311cd71232a001d72623a",
".git/objects/dd/3c98dba144a7930cc562f5fe8af4629afa0431": "8dca4a4f8a42962fc09628b8a0d92612",
".git/objects/e4/4d9e786e29b1e2ad96216aff277f215784bdd2": "4cb0786f20356780c9753f94d26e7257",
".git/objects/e4/6087754122414ffc6a8839d7bbdc6eed5c558c": "4a5446726a8eee505f6526ddad89f1a6",
".git/objects/e6/b745f90f2a4d1ee873fc396496c110db8ff0f3": "2933b2b2ca80c66b96cf80cd73d4cd16",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/f1/8a1de1a39cab5af96628ca7b5e6ba9c07d3cb1": "925e764f55ed7ad654e167c90c5bf080",
".git/objects/f7/14a514d94e495095e2f1e525a341eade187c17": "ca0d4350dcdad8026382089554e0448e",
".git/objects/f7/4b29b1668a404305f5bc54b3f9b7ae4d32f445": "67fc5c3854fcf2a23c3985696322bb20",
".git/objects/fa/4353fb731e6b26ba9428f9a0888d778c340010": "b4f50a002b6c4bdf0136bf9f295ce4fc",
".git/objects/fd/b9f0b76775357f66f39343459682b35732407e": "34b72c7e0c0e3dbbb24dcdd81d376379",
".git/refs/heads/gh-pages": "56dbda3d52d09a636c93018e4aa573d8",
".git/refs/heads/master": "df21bd8698ee408f33b5d35343fb3037",
"assets/AssetManifest.bin": "f02830a293d0f6914f9306dcd24bea61",
"assets/AssetManifest.bin.json": "02b3dfef106c247db68a20bb28945ac9",
"assets/AssetManifest.json": "94a67aac79a172aa8a983940d3bcdb73",
"assets/assets/fonts/Roboto-Bold.ttf": "e07df86cef2e721115583d61d1fb68a6",
"assets/assets/fonts/Roboto-Medium.ttf": "58aef543c97bbaf6a9896e8484456d98",
"assets/assets/fonts/Roboto-Regular.ttf": "11eabca2251325cfc5589c9c6fb57b46",
"assets/assets/fonts/WorkSans-Bold.ttf": "1fed2d8028f8f5356cbecedb03427405",
"assets/assets/fonts/WorkSans-Medium.ttf": "488b6f72b6183415e7a20aafa803a0c8",
"assets/assets/fonts/WorkSans-Regular.ttf": "30be604d29fd477c201fb1d6e668eaeb",
"assets/assets/fonts/WorkSans-SemiBold.ttf": "6f8da6d25c25d58ef3ec1c8b7c0e69c3",
"assets/assets/images/database.png": "59a142e78990dc27c41250d6b0be0e57",
"assets/assets/images/feedbackImage.jpg": "6ffd10385faa8a4bbc28dd660b11d074",
"assets/assets/images/feedbackImage.png": "5f8e9064f54cf51a70fee2da78a5b014",
"assets/assets/images/google.png": "8a8750564e7b137088af03f0452bb449",
"assets/assets/images/helpImage.jpg": "e658c75f2b4a941391cd7859105d90e1",
"assets/assets/images/helpImage.png": "2bff0fc93675d32f89db50f2d3e2a5b1",
"assets/assets/images/inviteImage.jpg": "704ed2b53bf8b51d3f0872e668420405",
"assets/assets/images/inviteImage.png": "4d337cf829c67258aa3aae385f5ec31c",
"assets/assets/images/login.jpg": "131cf2cc374b2470f57004545d1bcc37",
"assets/assets/images/shopme.png": "29a3b0b91269e5051e95a4fb6bdb5529",
"assets/assets/images/supportIcon.png": "2eb21b9823a538c996ec667e17388322",
"assets/assets/images/userImage.jpg": "aad8fffaa94d67db126ed8790c8644b8",
"assets/assets/images/userImage.png": "f2bb51f7c32f93c3433749ed79fc81cb",
"assets/assets/img/any.png": "4942771a4c00c3b943a2a3f45ae83e21",
"assets/assets/img/area1.png": "9cbfec64c29ec6821547f1c5093f38b7",
"assets/assets/img/area2.png": "2863c486c15808e8f105ccac2febfdbc",
"assets/assets/img/area3.png": "e85a8d2207edfb0325369d93982fba03",
"assets/assets/img/back.png": "af6b0e6121d6eb48289cce3a3b8d8963",
"assets/assets/img/bell.png": "929723572aa737a354244ca14fe5659b",
"assets/assets/img/bottle.png": "840d3c89291f9d3b0a859d7479c10d0c",
"assets/assets/img/breakfast.png": "1d2b0e6a7e46a44723131c663471f811",
"assets/assets/img/burned.png": "2ffad4b8dff525e57473142f0265b6bd",
"assets/assets/img/card.png": "c220ded1b8b6ca535e7df54ad9b39c00",
"assets/assets/img/cash.png": "9d1e013d6b2b62f7b3f8a294491abbd2",
"assets/assets/img/dinner.png": "d61779f47b560d09b0df15b346323ac4",
"assets/assets/img/eaten.png": "3f7d6f5aea8996d15d52c4c2268abd45",
"assets/assets/img/fitness_app.png": "bd55b7dc68210a0a5e6fa9341a47dbaf",
"assets/assets/img/glass.png": "266bca612c726abd6e481a4d890cef8e",
"assets/assets/img/great.jpg": "5e8fb90d7becec39648e581d954a4504",
"assets/assets/img/great.png": "8feadf4cd2794272ab4b27ffd66279e7",
"assets/assets/img/logo.png": "96810c93a06c80e52eb1d1f1cea1a05a",
"assets/assets/img/lunch.png": "6855159f38835c1f03289b102a2e8b52",
"assets/assets/img/movil.png": "1f417720a706a933af2d46e4b482c6e3",
"assets/assets/img/placeholder.png": "9f66f060031f801185eb35001cfbbd9d",
"assets/assets/img/placeholders.png": "93a4ecb5de3200d99d88f414be57a960",
"assets/assets/img/runner.png": "efb26bd46e91d305bda3b4b3c5a57c54",
"assets/assets/img/snack.png": "14a3e91c7a517b0a2f71dbcd86d2104d",
"assets/assets/img/tab_1.png": "b2a5f1ed83ceb8b194cd162bf1ae7b81",
"assets/assets/img/tab_1s.png": "7d14dae8755b3ba6465cc4100faf9130",
"assets/assets/img/tab_2.png": "5b7224852ee54c400e4ac3d8912c5209",
"assets/assets/img/tab_2s.png": "e17f599b36599217cef7af9a2ef7b27a",
"assets/assets/img/tab_3.png": "2939c0ab38fe43b6244304d593c2f1b4",
"assets/assets/img/tab_3s.png": "0e1e6b2987f99fc08355db419408363f",
"assets/assets/img/tab_4.png": "363050b7417636940303062a213ef26d",
"assets/assets/img/tab_4s.png": "03bf4ba0dc46a4cdeec41cdc30606067",
"assets/assets/introduction_animation/care_image.png": "ae631d1aa45674248e581ccd6f34067e",
"assets/assets/introduction_animation/introduction_animation.png": "309f80cbbe9ba84d2d643677c7853907",
"assets/assets/introduction_animation/introduction_image.png": "30421757bb57eab3439354f4dc4e31c2",
"assets/assets/introduction_animation/introduction_image1.png": "307c773d181ceeb899559add51c7acb4",
"assets/assets/introduction_animation/mood_dairy_image.png": "d6e7c7f4c210a5f2e0f468767e2b4344",
"assets/assets/introduction_animation/relax_image.png": "05d1133baf6082b8dd1edbd4495769cd",
"assets/assets/introduction_animation/welcome.png": "62ee1aa32560e9c63a2017424019528b",
"assets/FontManifest.json": "92d40a44a40733d060286a8973a3bd6c",
"assets/fonts/MaterialIcons-Regular.otf": "fc5d6be55e192e92790e59f5d6c67491",
"assets/NOTICES": "26f9d4c781a05a6c7cc1a541faf5b02a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "5ac99533bd9dc46227434b4853c3e532",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "093d2cde7075fcffb24ab215668d0da2",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "1e17b1ec3152f29bf783bd42db8b6023",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "73584c1a3367e3eaf757647a8f5c5989",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "143af6ff368f9cd21c863bfa4274c406",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "2fc47c0a0c3c7af8542b601634fe9674",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "cea91d4c66eaf3285c9a39a6b74d9450",
"flutter.js": "59a12ab9d00ae8f8096fffc417b6e84f",
"icons/Icon-192.png": "d367c00b0cfb61ef9df0330cc73abfd5",
"icons/Icon-512.png": "e066e811c80ebf9bd3f05a65fff342a8",
"icons/Icon-maskable-192.png": "81859bf11e667edb8a83dcbe76b0a280",
"icons/Icon-maskable-512.png": "950a82e6d9db867cbc182eb2571d284e",
"index.html": "08d4fc0187b7de6a6897dae0f90bd353",
"/": "08d4fc0187b7de6a6897dae0f90bd353",
"main.dart.js": "e5e539b2f826c8945e4bf1183e59bf36",
"manifest.json": "187087c1e5ecc2e9a15f58bf51e1f535",
"splash/img/dark-1x.png": "20f9ba5456e294f018513037b9410742",
"splash/img/dark-2x.png": "e6c64b9457169d6346e2aa3ae7453443",
"splash/img/dark-3x.png": "24386166e5321b98b8a827a4b264d307",
"splash/img/dark-4x.png": "81a2dd6961df4217d9d646613041092a",
"splash/img/light-1x.png": "20f9ba5456e294f018513037b9410742",
"splash/img/light-2x.png": "e6c64b9457169d6346e2aa3ae7453443",
"splash/img/light-3x.png": "24386166e5321b98b8a827a4b264d307",
"splash/img/light-4x.png": "81a2dd6961df4217d9d646613041092a",
"version.json": "39e49fe9d60884959b2229addf1440ba"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
