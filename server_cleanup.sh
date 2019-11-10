#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source $STORAGE_ROOT/yiimp/.yiimp.conf
cd $HOME/multipool/yiimp_single

echo -e " Installing cron screens to crontab...$COL_RESET"
(crontab -l 2>/dev/null; echo "@reboot sleep 20 && /home/crypto-data/yiimp/starts/screens.start.sh") | crontab -
if [[ ("$CoinPort" == "no") ]]; then
(crontab -l 2>/dev/null; echo "@reboot sleep 20 && /home/crypto-data/yiimp/starts/stratum.start.sh") | crontab -
fi
(crontab -l 2>/dev/null; echo "@reboot source /etc/functions.sh") | crontab -
(crontab -l 2>/dev/null; echo "@reboot source /etc/multipool.conf") | crontab -
sudo cp -r first_boot.sh $STORAGE_ROOT/yiimp/
echo -e "$GREEN Crontab system complete...$COL_RESET"

echo -e " Creating YiiMP Screens startup script...$COL_RESET"

echo '#!/usr/bin/env bash
source /etc/multipool.conf
# Ugly way to remove junk coins from initial YiiMP database on first boot
source $STORAGE_ROOT/yiimp/.yiimp.conf
if [[ ! -e '$STORAGE_ROOT/yiimp/first_boot.sh' ]]; then
echo
else
source $STORAGE_ROOT/yiimp/first_boot.sh
fi
################################################################################
# Author: cryptopool.builders
#
#
# Program: yiimp screen startup script
#
# BTC Donation: 12Pt3vQhQpXvyzBd5qcoL17ouhNFyihyz5
#
################################################################################
sudo chmod 777 $STORAGE_ROOT/yiimp/site/log/.
sudo chmod 777 $STORAGE_ROOT/yiimp/site/log/debug.log
LOG_DIR=$STORAGE_ROOT/yiimp/site/log
CRONS=$STORAGE_ROOT/yiimp/site/crons
screen -dmS main bash $CRONS/main.sh
screen -dmS loop2 bash $CRONS/loop2.sh
screen -dmS blocks bash $CRONS/blocks.sh
screen -dmS debug tail -f $LOG_DIR/debug.log
' | sudo -E tee $STORAGE_ROOT/yiimp/starts/screens.start.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/starts/screens.start.sh

echo -e " Creating Stratum screens start script...$COL_RESET"

echo '#!/usr/bin/env bash
################################################################################
# Author: cryptopool.builders
#
#
# Program: yiimp stratum startup script
#
# BTC Donation: 12Pt3vQhQpXvyzBd5qcoL17ouhNFyihyz5
#
################################################################################
source /etc/multipool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
STRATUM_DIR=$STORAGE_ROOT/yiimp/site/stratum
LOG_DIR=$STORAGE_ROOT/yiimp/site/log
screen -dmS c11 bash $STRATUM_DIR/run.sh c11
screen -dmS deep bash $STRATUM_DIR/run.sh deep
screen -dmS x11 bash $STRATUM_DIR/run.sh x11
screen -dmS 2x11evo bash $STRATUM_DIR/run.sh x11evo
screen -dmS x13 bash $STRATUM_DIR/run.sh x13
screen -dmS x14 bash bash $STRATUM_DIR/run.sh x14
screen -dmS x15 bash $STRATUM_DIR/run.sh x15
screen -dmS x17 bash $STRATUM_DIR/run.sh x17
screen -dmS xevan bash $STRATUM_DIR/run.sh xevan
screen -dmS timetravel bash $STRATUM_DIR/run.sh timetravel
screen -dmS bitcore bash $STRATUM_DIR/run.sh bitcore
screen -dmS hmq1725 bash $STRATUM_DIR/run.sh hmq1725
screen -dmS tribus bash $STRATUM_DIR/run.sh tribus
screen -dmS sha bash $STRATUM_DIR/run.sh sha
screen -dmS 2sha256t bash $STRATUM_DIR/run.sh sha256t
screen -dmS scrypt bash $STRATUM_DIR/run.sh scrypt
screen -dmS 2scryptn bash $STRATUM_DIR/run.sh scryptn
screen -dmS luffa bash $STRATUM_DIR/run.sh luffa
screen -dmS neo bash $STRATUM_DIR/run.sh neo
screen -dmS nist5 bash $STRATUM_DIR/run.sh nist5
screen -dmS penta bash $STRATUM_DIR/run.sh penta
screen -dmS quark bash $STRATUM_DIR/run.sh quark
screen -dmS qubit bash $STRATUM_DIR/run.sh qubit
screen -dmS jha bash $STRATUM_DIR/run.sh jha
screen -dmS dmd-gr bash $STRATUM_DIR/run.sh dmd-gr
screen -dmS myr-gr bash $STRATUM_DIR/run.sh myr-gr
screen -dmS lbry bash $STRATUM_DIR/run.sh lbry
screen -dmS lyra2 bash $STRATUM_DIR/run.sh lyra2
screen -dmS 2lyra2v2 bash $STRATUM_DIR/run.sh lyra2v2
screen -dmS zero bash $STRATUM_DIR/run.sh lyra2z
screen -dmS blakecoin bash $STRATUM_DIR/run.sh blakecoin # blake 8
screen -dmS blake bash $STRATUM_DIR/run.sh blake
screen -dmS 2blake2s bash $STRATUM_DIR/run.sh blake2s
screen -dmS vanilla bash $STRATUM_DIR/run.sh vanilla # blake 8
screen -dmS decred bash $STRATUM_DIR/run.sh decred # blake 14
screen -dmS keccak bash $STRATUM_DIR/run.sh keccak
screen -dmS whirlpool bash $STRATUM_DIR/run.sh whirlpool
screen -dmS skein bash $STRATUM_DIR/run.sh skein
screen -dmS 2skein2 bash $STRATUM_DIR/run.sh skein2
screen -dmS yescrypt bash $STRATUM_DIR/run.sh yescrypt
screen -dmS zr5 bash $STRATUM_DIR/run.sh zr5
screen -dmS sib bash $STRATUM_DIR/run.sh sib
screen -dmS m7m sudo bash $STRATUM_DIR/run.sh m7m
screen -dmS veltor bash $STRATUM_DIR/run.sh veltor
screen -dmS velvet bash $STRATUM_DIR/run.sh velvet
screen -dmS argon2 bash $STRATUM_DIR/run.sh argon2
screen -dmS groestl bash $STRATUM_DIR/run.sh groestl
screen -dmS skunk bash $STRATUM_DIR/run.sh skunk
screen -dmS phi1612 bash $STRATUM_DIR/run.sh phi1612
screen -dmS hsr bash $STRATUM_DIR/run.sh hsr
screen -dmS yescryptr16 bash $STRATUM_DIR/run.sh yescryptR16
screen -dmS x16r bash $STRATUM_DIR/run.sh x16r
' | sudo -E tee $STORAGE_ROOT/yiimp/starts/stratum.start.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/starts/stratum.start.sh

echo '
source /etc/multipool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
LOG_DIR=$STORAGE_ROOT/yiimp/site/log
CRONS=$STORAGE_ROOT/yiimp/site/crons
STRATUM_DIR=$STORAGE_ROOT/yiimp/site/stratum
' | sudo -E tee $STORAGE_ROOT/yiimp/.prescreens.start.conf >/dev/null 2>&1

echo "source /etc/multipool.conf" | hide_outputt tee -a ~/.bashrc
echo "source $STORAGE_ROOT/yiimp/.prescreens.start.conf" | hide_outputt tee -a ~/.bashrc
echo -e "$GREEN YiiMP Screens added...$COL_RESET"

exec sudo su -l $USER
echo "Removing junk coins from YiiMP Database, this may take several minutes...$COL_RESET"
hide_output sg yiimpadmin yiimp coin MDT delete & spinner
hide_output sg yiimpadmin yiimp coin FLAX delete & spinner
hide_output sg yiimpadmin yiimp coin CHC delete & spinner
hide_output sg yiimpadmin yiimp coin DRP delete & spinner
hide_output sg yiimpadmin yiimp coin VTC delete & spinner
hide_output sg yiimpadmin yiimp coin FTC delete & spinner
hide_output sg yiimpadmin yiimp coin UFO delete & spinner
hide_output sg yiimpadmin yiimp coin PXC delete & spinner
hide_output sg yiimpadmin yiimp coin HAL delete & spinner
hide_output sg yiimpadmin yiimp coin XAI delete & spinner
hide_output sg yiimpadmin yiimp coin QRK delete & spinner
hide_output sg yiimpadmin yiimp coin MUE delete & spinner
hide_output sg yiimpadmin yiimp coin BOD delete & spinner
hide_output sg yiimpadmin yiimp coin SRC delete & spinner
hide_output sg yiimpadmin yiimp coin BTQ delete & spinner
hide_output sg yiimpadmin yiimp coin GEO delete & spinner
hide_output sg yiimpadmin yiimp coin DGB delete & spinner
hide_output sg yiimpadmin yiimp coin CYP delete & spinner
hide_output sg yiimpadmin yiimp coin IDC delete & spinner
hide_output sg yiimpadmin yiimp coin NEOS delete & spinner
hide_output sg yiimpadmin yiimp coin MYR delete & spinner
hide_output sg yiimpadmin yiimp coin XDC delete & spinner
hide_output sg yiimpadmin yiimp coin SKC delete & spinner
hide_output sg yiimpadmin yiimp coin LOG delete & spinner
hide_output sg yiimpadmin yiimp coin ILM delete & spinner
hide_output sg yiimpadmin yiimp coin START delete & spinner
hide_output sg yiimpadmin yiimp coin URO delete & spinner
hide_output sg yiimpadmin yiimp coin DASH delete & spinner
hide_output sg yiimpadmin yiimp coin BSC delete & spinner
hide_output sg yiimpadmin yiimp coin HEDG delete & spinner
hide_output sg yiimpadmin yiimp coin AMBER delete & spinner
hide_output sg yiimpadmin yiimp coin HTML5 delete & spinner
hide_output sg yiimpadmin yiimp coin ZRC delete & spinner
hide_output sg yiimpadmin yiimp coin UNF delete & spinner
hide_output sg yiimpadmin yiimp coin DES delete & spinner
hide_output sg yiimpadmin yiimp coin KUMA delete & spinner
hide_output sg yiimpadmin yiimp coin MEME delete & spinner
hide_output sg yiimpadmin yiimp coin FOOT delete & spinner
hide_output sg yiimpadmin yiimp coin UMO delete & spinner
hide_output sg yiimpadmin yiimp coin G3N delete & spinner
hide_output sg yiimpadmin yiimp coin SHND delete & spinner
hide_output sg yiimpadmin yiimp coin WHIPPED delete & spinner
hide_output sg yiimpadmin yiimp coin FLY delete & spinner
hide_output sg yiimpadmin yiimp coin BUMBA delete & spinner
hide_output sg yiimpadmin yiimp coin EBG delete & spinner
hide_output sg yiimpadmin yiimp coin I0C delete & spinner
hide_output sg yiimpadmin yiimp coin CAPT delete & spinner
hide_output sg yiimpadmin yiimp coin PAK delete & spinner
hide_output sg yiimpadmin yiimp coin EUC delete & spinner
hide_output sg yiimpadmin yiimp coin GRE-OLD delete & spinner
hide_output sg yiimpadmin yiimp coin PR delete & spinner
hide_output sg yiimpadmin yiimp coin VGC delete & spinner
hide_output sg yiimpadmin yiimp coin CFC delete & spinner
hide_output sg yiimpadmin yiimp coin GAME delete & spinner
hide_output sg yiimpadmin yiimp coin FONZ delete & spinner
hide_output sg yiimpadmin yiimp coin DBIC delete & spinner
hide_output sg yiimpadmin yiimp coin TRUMP delete & spinner
hide_output sg yiimpadmin yiimp coin JIF delete & spinner
hide_output sg yiimpadmin yiimp coin EVIL delete & spinner
hide_output sg yiimpadmin yiimp coin EVO delete & spinner
hide_output sg yiimpadmin yiimp coin LTCR delete & spinner
hide_output sg yiimpadmin yiimp coin SANDG delete & spinner
hide_output sg yiimpadmin yiimp coin RICHX delete & spinner
hide_output sg yiimpadmin yiimp coin ADZ delete & spinner
hide_output sg yiimpadmin yiimp coin DGCS delete & spinner
hide_output sg yiimpadmin yiimp coin BOLI delete & spinner
hide_output sg yiimpadmin yiimp coin LGBTQ delete & spinner
hide_output sg yiimpadmin yiimp coin ZOOM delete & spinner
hide_output sg yiimpadmin yiimp coin YOC delete & spinner
hide_output sg yiimpadmin yiimp coin SIB delete & spinner
hide_output sg yiimpadmin yiimp coin OPES delete & spinner
hide_output sg yiimpadmin yiimp coin NKC delete & spinner
hide_output sg yiimpadmin yiimp coin MMXVI delete & spinner
hide_output sg yiimpadmin yiimp coin MBL delete & spinner
hide_output sg yiimpadmin yiimp coin KNC delete & spinner
hide_output sg yiimpadmin yiimp coin AR2 delete & spinner
hide_output sg yiimpadmin yiimp coin AND delete & spinner
hide_output sg yiimpadmin yiimp coin TROLL delete & spinner
hide_output sg yiimpadmin yiimp coin DNET delete & spinner
hide_output sg yiimpadmin yiimp coin DCR delete & spinner
hide_output sg yiimpadmin yiimp coin EGC delete & spinner
hide_output sg yiimpadmin yiimp coin MND delete & spinner
hide_output sg yiimpadmin yiimp coin BNT delete & spinner
hide_output sg yiimpadmin yiimp coin AMS delete & spinner
hide_output sg yiimpadmin yiimp coin INFX delete & spinner
hide_output sg yiimpadmin yiimp coin BSD delete & spinner
hide_output sg yiimpadmin yiimp coin HTC delete & spinner
hide_output sg yiimpadmin yiimp coin CZECO delete & spinner
hide_output sg yiimpadmin yiimp coin EDRC delete & spinner
hide_output sg yiimpadmin yiimp coin FTP delete & spinner
hide_output sg yiimpadmin yiimp coin OP delete & spinner
hide_output sg yiimpadmin yiimp coin CHAI delete & spinner
hide_output sg yiimpadmin yiimp coin REV delete & spinner
hide_output sg yiimpadmin yiimp coin PULSE delete & spinner
hide_output sg yiimpadmin yiimp coin XCT delete & spinner
hide_output sg yiimpadmin yiimp coin STS delete & spinner
hide_output sg yiimpadmin yiimp coin EC delete & spinner
hide_output sg yiimpadmin yiimp coin CYG delete & spinner
hide_output sg yiimpadmin yiimp coin VAL delete & spinner
hide_output sg yiimpadmin yiimp coin TBC delete & spinner
hide_output sg yiimpadmin yiimp coin CRBIT delete & spinner
hide_output sg yiimpadmin yiimp coin GMX delete & spinner
hide_output sg yiimpadmin yiimp coin HODL delete & spinner
hide_output sg yiimpadmin yiimp coin KLC delete & spinner
hide_output sg yiimpadmin yiimp coin BUZZ delete & spinner
hide_output sg yiimpadmin yiimp coin ADCN delete & spinner
hide_output sg yiimpadmin yiimp coin RBIES delete & spinner
hide_output sg yiimpadmin yiimp coin SEC delete & spinner
hide_output sg yiimpadmin yiimp coin XID delete & spinner
hide_output sg yiimpadmin yiimp coin BTCU delete & spinner
hide_output sg yiimpadmin yiimp coin WARP delete & spinner
hide_output sg yiimpadmin yiimp coin CPNC delete & spinner
hide_output sg yiimpadmin yiimp coin HIRE delete & spinner
hide_output sg yiimpadmin yiimp coin SLS delete & spinner
hide_output sg yiimpadmin yiimp coin XHI delete & spinner
hide_output sg yiimpadmin yiimp coin RADS delete & spinner
hide_output sg yiimpadmin yiimp coin BTP delete & spinner
hide_output sg yiimpadmin yiimp coin X2 delete & spinner
hide_output sg yiimpadmin yiimp coin HMP delete & spinner
hide_output sg yiimpadmin yiimp coin BRONZ delete & spinner
hide_output sg yiimpadmin yiimp coin RUBIT delete & spinner
hide_output sg yiimpadmin yiimp coin REP delete & spinner
hide_output sg yiimpadmin yiimp coin SPL delete & spinner
hide_output sg yiimpadmin yiimp coin CIONZ delete & spinner
hide_output sg yiimpadmin yiimp coin SCRT delete & spinner
hide_output sg yiimpadmin yiimp coin DEUR delete & spinner
hide_output sg yiimpadmin yiimp coin VOX delete & spinner
hide_output sg yiimpadmin yiimp coin CLUB delete & spinner
hide_output sg yiimpadmin yiimp coin SCOT delete & spinner
hide_output sg yiimpadmin yiimp coin FLOZ delete & spinner
hide_output sg yiimpadmin yiimp coin STATS delete & spinner
hide_output sg yiimpadmin yiimp coin HZDOGE delete & spinner
hide_output sg yiimpadmin yiimp coin WLC delete & spinner
hide_output sg yiimpadmin yiimp coin BITUSD delete & spinner
hide_output sg yiimpadmin yiimp coin BITCNY delete & spinner
hide_output sg yiimpadmin yiimp coin FNX delete & spinner
hide_output sg yiimpadmin yiimp coin APC delete & spinner
hide_output sg yiimpadmin yiimp coin XLM delete & spinner
hide_output sg yiimpadmin yiimp coin AGRS delete & spinner
hide_output sg yiimpadmin yiimp coin DROP delete & spinner
hide_output sg yiimpadmin yiimp coin AMP delete & spinner
hide_output sg yiimpadmin yiimp coin ANTI delete & spinner
hide_output sg yiimpadmin yiimp coin 1337 delete & spinner
hide_output sg yiimpadmin yiimp coin TRBO delete & spinner
hide_output sg yiimpadmin yiimp coin BIC delete & spinner
hide_output sg yiimpadmin yiimp coin SOIL delete & spinner
hide_output sg yiimpadmin yiimp coin OMNI delete & spinner
hide_output sg yiimpadmin yiimp coin CUBE delete & spinner
hide_output sg yiimpadmin yiimp coin BAC delete & spinner
hide_output sg yiimpadmin yiimp coin WOP delete & spinner
hide_output sg yiimpadmin yiimp coin FCT delete & spinner
hide_output sg yiimpadmin yiimp coin PRT delete & spinner
hide_output sg yiimpadmin yiimp coin CBIT delete & spinner
hide_output sg yiimpadmin yiimp coin NEU delete & spinner
hide_output sg yiimpadmin yiimp coin STEPS delete & spinner
hide_output sg yiimpadmin yiimp coin EXP delete & spinner
hide_output sg yiimpadmin yiimp coin BCY delete & spinner
hide_output sg yiimpadmin yiimp coin PRIME delete & spinner
hide_output sg yiimpadmin yiimp coin SHF delete & spinner
hide_output sg yiimpadmin yiimp coin SWING delete & spinner
hide_output sg yiimpadmin yiimp coin MI delete & spinner
hide_output sg yiimpadmin yiimp coin MACRO delete & spinner
hide_output sg yiimpadmin yiimp coin SC delete & spinner
hide_output sg yiimpadmin yiimp coin GCR delete & spinner
hide_output sg yiimpadmin yiimp coin MAPC delete & spinner
hide_output sg yiimpadmin yiimp coin GCC delete & spinner
hide_output sg yiimpadmin yiimp coin TX delete & spinner
hide_output sg yiimpadmin yiimp coin ETH delete & spinner
hide_output sg yiimpadmin yiimp coin CRE delete & spinner
hide_output sg yiimpadmin yiimp coin AEON delete & spinner
hide_output sg yiimpadmin yiimp coin GSY delete & spinner
hide_output sg yiimpadmin yiimp coin CHIP delete & spinner
hide_output sg yiimpadmin yiimp coin BTCHC delete & spinner
hide_output sg yiimpadmin yiimp coin AXIOM delete & spinner
hide_output sg yiimpadmin yiimp coin FUEL delete & spinner
hide_output sg yiimpadmin yiimp coin BIOS delete & spinner
hide_output sg yiimpadmin yiimp coin CPC delete & spinner
hide_output sg yiimpadmin yiimp coin IBITS delete & spinner
hide_output sg yiimpadmin yiimp coin DIGS delete & spinner
hide_output sg yiimpadmin yiimp coin NOC delete & spinner
hide_output sg yiimpadmin yiimp coin MCZ delete & spinner
hide_output sg yiimpadmin yiimp coin BANX delete & spinner
hide_output sg yiimpadmin yiimp coin CPN delete & spinner
hide_output sg yiimpadmin yiimp coin SPRTS delete & spinner
hide_output sg yiimpadmin yiimp coin SPROUT delete & spinner
hide_output sg yiimpadmin yiimp coin NUKE delete & spinner
hide_output sg yiimpadmin yiimp coin 2BACCO delete & spinner
hide_output sg yiimpadmin yiimp coin FIC delete & spinner
hide_output sg yiimpadmin yiimp coin LFO delete & spinner
hide_output sg yiimpadmin yiimp coin VERSA delete & spinner
hide_output sg yiimpadmin yiimp coin MCAR delete & spinner
hide_output sg yiimpadmin yiimp coin CARB delete & spinner
hide_output sg yiimpadmin yiimp coin ZUR delete & spinner
hide_output sg yiimpadmin yiimp coin VAPE delete & spinner
hide_output sg yiimpadmin yiimp coin TALK delete & spinner
hide_output sg yiimpadmin yiimp coin RUM delete & spinner
hide_output sg yiimpadmin yiimp coin PPCD delete & spinner
hide_output sg yiimpadmin yiimp coin PHO delete & spinner
hide_output sg yiimpadmin yiimp coin P0001 delete & spinner
hide_output sg yiimpadmin yiimp coin NODE delete & spinner
hide_output sg yiimpadmin yiimp coin MRC delete & spinner
hide_output sg yiimpadmin yiimp coin ISO delete & spinner
hide_output sg yiimpadmin yiimp coin HANSA delete & spinner
hide_output sg yiimpadmin yiimp coin FX01 delete & spinner
hide_output sg yiimpadmin yiimp coin FRSH delete & spinner
hide_output sg yiimpadmin yiimp coin FIMK delete & spinner
hide_output sg yiimpadmin yiimp coin FAIL delete & spinner
hide_output sg yiimpadmin yiimp coin DRM delete & spinner
hide_output sg yiimpadmin yiimp coin DRK delete & spinner
hide_output sg yiimpadmin yiimp coin CV2 delete & spinner
hide_output sg yiimpadmin yiimp coin BTRHA delete & spinner
hide_output sg yiimpadmin yiimp coin ALCUREX delete & spinner
hide_output sg yiimpadmin yiimp coin BNX delete & spinner
hide_output sg yiimpadmin yiimp coin QUIT delete & spinner
hide_output sg yiimpadmin yiimp coin V delete & spinner
hide_output sg yiimpadmin yiimp coin PLC delete & spinner
hide_output sg yiimpadmin yiimp coin GRW delete & spinner
hide_output sg yiimpadmin yiimp coin DUO delete & spinner
hide_output sg yiimpadmin yiimp coin ANI delete & spinner
hide_output sg yiimpadmin yiimp coin CDC delete & spinner
hide_output sg yiimpadmin yiimp coin CX delete & spinner
hide_output sg yiimpadmin yiimp coin MARS delete & spinner
hide_output sg yiimpadmin yiimp coin SHA delete & spinner
hide_output sg yiimpadmin yiimp coin FETISH delete & spinner
hide_output sg yiimpadmin yiimp coin EXC delete & spinner
hide_output sg yiimpadmin yiimp coin BDSM delete & spinner
hide_output sg yiimpadmin yiimp coin OFF delete & spinner
hide_output sg yiimpadmin yiimp coin EMC delete & spinner
hide_output sg yiimpadmin yiimp coin BLZ delete & spinner
hide_output sg yiimpadmin yiimp coin CHAO delete & spinner
hide_output sg yiimpadmin yiimp coin CNO delete & spinner
hide_output sg yiimpadmin yiimp coin FUNK delete & spinner
hide_output sg yiimpadmin yiimp coin UNIC delete & spinner
hide_output sg yiimpadmin yiimp coin DUCK delete & spinner
hide_output sg yiimpadmin yiimp coin BSY delete & spinner
hide_output sg yiimpadmin yiimp coin SPN delete & spinner
hide_output sg yiimpadmin yiimp coin IPC delete & spinner
hide_output sg yiimpadmin yiimp coin '$MINEZ' delete & spinner
hide_output sg yiimpadmin yiimp coin '$MINEW' delete & spinner
hide_output sg yiimpadmin yiimp coin ADD delete & spinner
hide_output sg yiimpadmin yiimp coin '$MINE' delete & spinner
hide_output sg yiimpadmin yiimp coin FTCC delete & spinner
hide_output sg yiimpadmin yiimp coin CIV delete & spinner
hide_output sg yiimpadmin yiimp coin TOP delete & spinner
hide_output sg yiimpadmin yiimp coin TTY delete & spinner
hide_output sg yiimpadmin yiimp coin NTC delete & spinner
hide_output sg yiimpadmin yiimp coin KIWI delete & spinner
hide_output sg yiimpadmin yiimp coin XPL delete & spinner
hide_output sg yiimpadmin yiimp coin XGR delete & spinner
hide_output sg yiimpadmin yiimp coin '$$$' delete & spinner
hide_output sg yiimpadmin yiimp coin 66 delete & spinner
hide_output sg yiimpadmin yiimp coin MDC delete & spinner
hide_output sg yiimpadmin yiimp coin SVC delete & spinner
hide_output sg yiimpadmin yiimp coin DARK delete & spinner
hide_output sg yiimpadmin yiimp coin POP delete & spinner
hide_output sg yiimpadmin yiimp coin WSX delete & spinner
hide_output sg yiimpadmin yiimp coin DOT delete & spinner
hide_output sg yiimpadmin yiimp coin YOVI delete & spinner
hide_output sg yiimpadmin yiimp coin HXX delete & spinner
hide_output sg yiimpadmin yiimp coin CRPS delete & spinner
hide_output sg yiimpadmin yiimp coin BAM delete & spinner
hide_output sg yiimpadmin yiimp coin SJW delete & spinner
hide_output sg yiimpadmin yiimp coin GMCX delete & spinner
hide_output sg yiimpadmin yiimp coin SPX delete & spinner
hide_output sg yiimpadmin yiimp coin EXT delete & spinner
hide_output sg yiimpadmin yiimp coin TENNET delete & spinner
hide_output sg yiimpadmin yiimp coin KC delete & spinner
hide_output sg yiimpadmin yiimp coin BLUS delete & spinner
hide_output sg yiimpadmin yiimp coin XRA delete & spinner
hide_output sg yiimpadmin yiimp coin SPEC delete & spinner
hide_output sg yiimpadmin yiimp coin EA delete & spinner
hide_output sg yiimpadmin yiimp coin TAGR delete & spinner
hide_output sg yiimpadmin yiimp coin HAZE delete & spinner
hide_output sg yiimpadmin yiimp coin TAM delete & spinner
hide_output sg yiimpadmin yiimp coin POLY delete & spinner
hide_output sg yiimpadmin yiimp coin INDEX delete & spinner
hide_output sg yiimpadmin yiimp coin GENI delete & spinner
hide_output sg yiimpadmin yiimp coin BUCKS delete & spinner
hide_output sg yiimpadmin yiimp coin SPKTR delete & spinner
hide_output sg yiimpadmin yiimp coin GENE delete & spinner
hide_output sg yiimpadmin yiimp coin GRM delete & spinner
hide_output sg yiimpadmin yiimp coin DIBS delete & spinner
hide_output sg yiimpadmin yiimp coin GTFO delete & spinner
hide_output sg yiimpadmin yiimp coin FUTC delete & spinner
hide_output sg yiimpadmin yiimp coin XVI delete & spinner
hide_output sg yiimpadmin yiimp coin GLOBE delete & spinner
hide_output sg yiimpadmin yiimp coin SMSR delete & spinner
hide_output sg yiimpadmin yiimp coin CIRC delete & spinner
hide_output sg yiimpadmin yiimp coin WOC2 delete & spinner
hide_output sg yiimpadmin yiimp coin NODX delete & spinner
hide_output sg yiimpadmin yiimp coin ERC delete & spinner
hide_output sg yiimpadmin yiimp coin SEN delete & spinner
hide_output sg yiimpadmin yiimp coin SAK delete & spinner
hide_output sg yiimpadmin yiimp coin EOC delete & spinner
hide_output sg yiimpadmin yiimp coin TRANSF delete & spinner
hide_output sg yiimpadmin yiimp coin GEN delete & spinner
hide_output sg yiimpadmin yiimp coin DRKT delete & spinner
hide_output sg yiimpadmin yiimp coin XCE delete & spinner
hide_output sg yiimpadmin yiimp coin XPH delete & spinner
hide_output sg yiimpadmin yiimp coin FIST delete & spinner
hide_output sg yiimpadmin yiimp coin DUB delete & spinner
hide_output sg yiimpadmin yiimp coin VAPOR delete & spinner
hide_output sg yiimpadmin yiimp coin ARPA delete & spinner
hide_output sg yiimpadmin yiimp coin BNB delete & spinner
hide_output sg yiimpadmin yiimp coin NANAS delete & spinner
hide_output sg yiimpadmin yiimp coin SEEDS delete & spinner
hide_output sg yiimpadmin yiimp coin OPTION delete & spinner
hide_output sg yiimpadmin yiimp coin DRA delete & spinner
hide_output sg yiimpadmin yiimp coin GLUCK delete & spinner
hide_output sg yiimpadmin yiimp coin EXB delete & spinner
hide_output sg yiimpadmin yiimp coin GREED delete & spinner
hide_output sg yiimpadmin yiimp coin MOIN delete & spinner
hide_output sg yiimpadmin yiimp coin Vcoin  delete & spinner
hide_output sg yiimpadmin yiimp coin TWLV delete & spinner
hide_output sg yiimpadmin yiimp coin RDN delete & spinner
hide_output sg yiimpadmin yiimp coin PSY delete & spinner
hide_output sg yiimpadmin yiimp coin ECC delete & spinner
hide_output sg yiimpadmin yiimp coin SNRG delete & spinner
hide_output sg yiimpadmin yiimp coin ADC delete & spinner
hide_output sg yiimpadmin yiimp coin CREVA delete & spinner
hide_output sg yiimpadmin yiimp coin VCN delete & spinner
hide_output sg yiimpadmin yiimp coin 32BIT delete & spinner
hide_output sg yiimpadmin yiimp coin XNA delete & spinner
hide_output sg yiimpadmin yiimp coin TWERK delete & spinner
hide_output sg yiimpadmin yiimp coin CS delete & spinner
hide_output sg yiimpadmin yiimp coin GENIUS delete & spinner
hide_output sg yiimpadmin yiimp coin PRE delete & spinner
hide_output sg yiimpadmin yiimp coin NICE delete & spinner
hide_output sg yiimpadmin yiimp coin CORG delete & spinner
hide_output sg yiimpadmin yiimp coin DB delete & spinner
hide_output sg yiimpadmin yiimp coin EQM delete & spinner
hide_output sg yiimpadmin yiimp coin FADE delete & spinner
hide_output sg yiimpadmin yiimp coin SED delete & spinner
hide_output sg yiimpadmin yiimp coin SKB delete & spinner
hide_output sg yiimpadmin yiimp coin TNG delete & spinner
hide_output sg yiimpadmin yiimp coin ARB delete & spinner
hide_output sg yiimpadmin yiimp coin DCC delete & spinner
hide_output sg yiimpadmin yiimp coin PTA delete & spinner
hide_output sg yiimpadmin yiimp coin MRB delete & spinner
hide_output sg yiimpadmin yiimp coin BTA delete & spinner
hide_output sg yiimpadmin yiimp coin GRT delete & spinner
hide_output sg yiimpadmin yiimp coin AST delete & spinner
hide_output sg yiimpadmin yiimp coin BA delete & spinner
hide_output sg yiimpadmin yiimp coin KRAK delete & spinner
hide_output sg yiimpadmin yiimp coin M1 delete & spinner
hide_output sg yiimpadmin yiimp coin 16BIT delete & spinner
hide_output sg yiimpadmin yiimp coin TB delete & spinner
hide_output sg yiimpadmin yiimp coin BIT16 delete & spinner
hide_output sg yiimpadmin yiimp coin CLV delete & spinner
hide_output sg yiimpadmin yiimp coin SHELL delete & spinner
hide_output sg yiimpadmin yiimp coin LIMX delete & spinner
hide_output sg yiimpadmin yiimp coin BTI delete & spinner
hide_output sg yiimpadmin yiimp coin FSN delete & spinner
hide_output sg yiimpadmin yiimp coin TKT delete & spinner
hide_output sg yiimpadmin yiimp coin FCS delete & spinner
hide_output sg yiimpadmin yiimp coin VTN delete & spinner
hide_output sg yiimpadmin yiimp coin EPC delete & spinner
hide_output sg yiimpadmin yiimp coin PKB delete & spinner
hide_output sg yiimpadmin yiimp coin GAM delete & spinner
hide_output sg yiimpadmin yiimp coin ISL delete & spinner
hide_output sg yiimpadmin yiimp coin VIRAL delete & spinner
hide_output sg yiimpadmin yiimp coin UTLE delete & spinner
hide_output sg yiimpadmin yiimp coin PNC delete & spinner
hide_output sg yiimpadmin yiimp coin GOAT delete & spinner
hide_output sg yiimpadmin yiimp coin EPY delete & spinner
hide_output sg yiimpadmin yiimp coin CTO delete & spinner
hide_output sg yiimpadmin yiimp coin SPC delete & spinner
hide_output sg yiimpadmin yiimp coin GRAV delete & spinner
hide_output sg yiimpadmin yiimp coin GPH delete & spinner
hide_output sg yiimpadmin yiimp coin UNIT delete & spinner
hide_output sg yiimpadmin yiimp coin BUB delete & spinner
hide_output sg yiimpadmin yiimp coin TDFB delete & spinner
hide_output sg yiimpadmin yiimp coin SPHR delete & spinner
hide_output sg yiimpadmin yiimp coin GUM delete & spinner
hide_output sg yiimpadmin yiimp coin XMS delete & spinner
hide_output sg yiimpadmin yiimp coin XSEED delete & spinner
hide_output sg yiimpadmin yiimp coin XNX delete & spinner
hide_output sg yiimpadmin yiimp coin XTP delete & spinner
hide_output sg yiimpadmin yiimp coin DOX delete & spinner
hide_output sg yiimpadmin yiimp coin QTZ delete & spinner
hide_output sg yiimpadmin yiimp coin UNAT-skein delete & spinner
hide_output sg yiimpadmin yiimp coin AIB delete & spinner
hide_output sg yiimpadmin yiimp coin GRAM delete & spinner
hide_output sg yiimpadmin yiimp coin SIGU delete & spinner
hide_output sg yiimpadmin yiimp coin BLITZ delete & spinner
hide_output sg yiimpadmin yiimp coin NIRO delete & spinner
hide_output sg yiimpadmin yiimp coin HUGE delete & spinner
hide_output sg yiimpadmin yiimp coin 7 delete & spinner
hide_output sg yiimpadmin yiimp coin DRZ delete & spinner
hide_output sg yiimpadmin yiimp coin UIS-qubit delete & spinner
hide_output sg yiimpadmin yiimp coin UIS-skein delete & spinner
hide_output sg yiimpadmin yiimp coin SLING delete & spinner
hide_output sg yiimpadmin yiimp coin COV delete & spinner
hide_output sg yiimpadmin yiimp coin NTRN delete & spinner
hide_output sg yiimpadmin yiimp coin CTK delete & spinner
hide_output sg yiimpadmin yiimp coin CF delete & spinner
hide_output sg yiimpadmin yiimp coin CGN delete & spinner
hide_output sg yiimpadmin yiimp coin OK delete & spinner
hide_output sg yiimpadmin yiimp coin 8BIT delete & spinner
hide_output sg yiimpadmin yiimp coin IEC delete & spinner
hide_output sg yiimpadmin yiimp coin P7C delete & spinner
hide_output sg yiimpadmin yiimp coin HZT delete & spinner
hide_output sg yiimpadmin yiimp coin LEA delete & spinner
hide_output sg yiimpadmin yiimp coin GIZ delete & spinner
hide_output sg yiimpadmin yiimp coin ETRUST delete & spinner
hide_output sg yiimpadmin yiimp coin XPRO delete & spinner
hide_output sg yiimpadmin yiimp coin TRON delete & spinner
hide_output sg yiimpadmin yiimp coin DECR delete & spinner
hide_output sg yiimpadmin yiimp coin RICE delete & spinner
hide_output sg yiimpadmin yiimp coin STP delete & spinner
hide_output sg yiimpadmin yiimp coin NXE delete & spinner
hide_output sg yiimpadmin yiimp coin AECC delete & spinner
hide_output sg yiimpadmin yiimp coin PLANET delete & spinner
hide_output sg yiimpadmin yiimp coin FIRE delete & spinner
hide_output sg yiimpadmin yiimp coin ANAL delete & spinner
hide_output sg yiimpadmin yiimp coin MTLMC3 delete & spinner
hide_output sg yiimpadmin yiimp coin TWIST delete & spinner
hide_output sg yiimpadmin yiimp coin CRIME delete & spinner
hide_output sg yiimpadmin yiimp coin BTCR delete & spinner
hide_output sg yiimpadmin yiimp coin TEC delete & spinner
hide_output sg yiimpadmin yiimp coin KARMA delete & spinner
hide_output sg yiimpadmin yiimp coin TCX delete & spinner
hide_output sg yiimpadmin yiimp coin TAB delete & spinner
hide_output sg yiimpadmin yiimp coin NDOGE delete & spinner
hide_output sg yiimpadmin yiimp coin GIFT delete & spinner
hide_output sg yiimpadmin yiimp coin BBCC delete & spinner
hide_output sg yiimpadmin yiimp coin TRICK delete & spinner
hide_output sg yiimpadmin yiimp coin DGMS delete & spinner
hide_output sg yiimpadmin yiimp coin CCB delete & spinner
hide_output sg yiimpadmin yiimp coin OZC delete & spinner
hide_output sg yiimpadmin yiimp coin STK delete & spinner
hide_output sg yiimpadmin yiimp coin SIC delete & spinner
hide_output sg yiimpadmin yiimp coin EGG delete & spinner
hide_output sg yiimpadmin yiimp coin EKN delete & spinner
hide_output sg yiimpadmin yiimp coin MRP delete & spinner
hide_output sg yiimpadmin yiimp coin QORA delete & spinner
hide_output sg yiimpadmin yiimp coin PXL delete & spinner
hide_output sg yiimpadmin yiimp coin CRY delete & spinner
hide_output sg yiimpadmin yiimp coin URC delete & spinner
hide_output sg yiimpadmin yiimp coin ICN delete & spinner
hide_output sg yiimpadmin yiimp coin OCTO delete & spinner
hide_output sg yiimpadmin yiimp coin EUR delete & spinner
hide_output sg yiimpadmin yiimp coin CAD delete & spinner
hide_output sg yiimpadmin yiimp coin CC delete & spinner
hide_output sg yiimpadmin yiimp coin XEM delete & spinner
hide_output sg yiimpadmin yiimp coin SLFI delete & spinner
hide_output sg yiimpadmin yiimp coin 256 delete & spinner
hide_output sg yiimpadmin yiimp coin ICASH delete & spinner
hide_output sg yiimpadmin yiimp coin BTCRY delete & spinner
hide_output sg yiimpadmin yiimp coin XDB delete & spinner
hide_output sg yiimpadmin yiimp coin ZIRK delete & spinner
hide_output sg yiimpadmin yiimp coin CRAVE delete & spinner
hide_output sg yiimpadmin yiimp coin BITZ delete & spinner
hide_output sg yiimpadmin yiimp coin OMC delete & spinner
hide_output sg yiimpadmin yiimp coin PAY delete & spinner
hide_output sg yiimpadmin yiimp coin LDOGE delete & spinner
hide_output sg yiimpadmin yiimp coin RBT delete & spinner
hide_output sg yiimpadmin yiimp coin ASN delete & spinner
hide_output sg yiimpadmin yiimp coin MINE delete & spinner
hide_output sg yiimpadmin yiimp coin XAU delete & spinner
hide_output sg yiimpadmin yiimp coin XFC delete & spinner
hide_output sg yiimpadmin yiimp coin UNC delete & spinner
hide_output sg yiimpadmin yiimp coin XCO delete & spinner
hide_output sg yiimpadmin yiimp coin VOYA delete & spinner
hide_output sg yiimpadmin yiimp coin XVC delete & spinner
hide_output sg yiimpadmin yiimp coin WBB delete & spinner
hide_output sg yiimpadmin yiimp coin ECASH delete & spinner
hide_output sg yiimpadmin yiimp coin MTR delete & spinner
hide_output sg yiimpadmin yiimp coin NSR delete & spinner
hide_output sg yiimpadmin yiimp coin GSM delete & spinner
hide_output sg yiimpadmin yiimp coin PTY delete & spinner
hide_output sg yiimpadmin yiimp coin LYB delete & spinner
hide_output sg yiimpadmin yiimp coin SUP delete & spinner
hide_output sg yiimpadmin yiimp coin CIN delete & spinner
hide_output sg yiimpadmin yiimp coin DD delete & spinner
hide_output sg yiimpadmin yiimp coin SMAC delete & spinner
hide_output sg yiimpadmin yiimp coin GRID delete & spinner
hide_output sg yiimpadmin yiimp coin SLM delete & spinner
hide_output sg yiimpadmin yiimp coin LTS delete & spinner
hide_output sg yiimpadmin yiimp coin XTC delete & spinner
hide_output sg yiimpadmin yiimp coin DGORE delete & spinner
hide_output sg yiimpadmin yiimp coin BITB delete & spinner
hide_output sg yiimpadmin yiimp coin BEAN delete & spinner
hide_output sg yiimpadmin yiimp coin PEN delete & spinner
hide_output sg yiimpadmin yiimp coin NVCD delete & spinner
hide_output sg yiimpadmin yiimp coin XPD delete & spinner
hide_output sg yiimpadmin yiimp coin CBX delete & spinner
hide_output sg yiimpadmin yiimp coin CELL delete & spinner
hide_output sg yiimpadmin yiimp coin KOBO delete & spinner
hide_output sg yiimpadmin yiimp coin LQD delete & spinner
hide_output sg yiimpadmin yiimp coin XTR delete & spinner
hide_output sg yiimpadmin yiimp coin 10K delete & spinner
hide_output sg yiimpadmin yiimp coin MYST delete & spinner
hide_output sg yiimpadmin yiimp coin BTCS delete & spinner
hide_output sg yiimpadmin yiimp coin XPB delete & spinner
hide_output sg yiimpadmin yiimp coin CETI delete & spinner
hide_output sg yiimpadmin yiimp coin OMA delete & spinner
hide_output sg yiimpadmin yiimp coin CCC delete & spinner
hide_output sg yiimpadmin yiimp coin XFB delete & spinner
hide_output sg yiimpadmin yiimp coin OBS delete & spinner
hide_output sg yiimpadmin yiimp coin SOON delete & spinner
hide_output sg yiimpadmin yiimp coin GIG delete & spinner
hide_output sg yiimpadmin yiimp coin XAP delete & spinner
hide_output sg yiimpadmin yiimp coin XBC delete & spinner
hide_output sg yiimpadmin yiimp coin XCH delete & spinner
hide_output sg yiimpadmin yiimp coin XCN delete & spinner
hide_output sg yiimpadmin yiimp coin XCP delete & spinner
hide_output sg yiimpadmin yiimp coin XDP delete & spinner
hide_output sg yiimpadmin yiimp coin XUSD delete & spinner
hide_output sg yiimpadmin yiimp coin YACC delete & spinner
hide_output sg yiimpadmin yiimp coin 1CR delete & spinner
hide_output sg yiimpadmin yiimp coin ACH delete & spinner
hide_output sg yiimpadmin yiimp coin ADN delete & spinner
hide_output sg yiimpadmin yiimp coin BCN delete & spinner
hide_output sg yiimpadmin yiimp coin BELA delete & spinner
hide_output sg yiimpadmin yiimp coin C2 delete & spinner
hide_output sg yiimpadmin yiimp coin CGA delete & spinner
hide_output sg yiimpadmin yiimp coin CHA delete & spinner
hide_output sg yiimpadmin yiimp coin CNMT delete & spinner
hide_output sg yiimpadmin yiimp coin CYC delete & spinner
hide_output sg yiimpadmin yiimp coin DIEM delete & spinner
hide_output sg yiimpadmin yiimp coin DSH delete & spinner
hide_output sg yiimpadmin yiimp coin FLDC delete & spinner
hide_output sg yiimpadmin yiimp coin GAP delete & spinner
hide_output sg yiimpadmin yiimp coin GDN delete & spinner
hide_output sg yiimpadmin yiimp coin GEMZ delete & spinner
hide_output sg yiimpadmin yiimp coin GOLD delete & spinner
hide_output sg yiimpadmin yiimp coin GRS delete & spinner
hide_output sg yiimpadmin yiimp coin HIRO delete & spinner
hide_output sg yiimpadmin yiimp coin HZ delete & spinner
hide_output sg yiimpadmin yiimp coin JLH delete & spinner
hide_output sg yiimpadmin yiimp coin LTBC delete & spinner
hide_output sg yiimpadmin yiimp coin MAID delete & spinner
hide_output sg yiimpadmin yiimp coin MCN delete & spinner
hide_output sg yiimpadmin yiimp coin MIL delete & spinner
hide_output sg yiimpadmin yiimp coin MMC delete & spinner
hide_output sg yiimpadmin yiimp coin MMNXT delete & spinner
hide_output sg yiimpadmin yiimp coin MNTA delete & spinner
hide_output sg yiimpadmin yiimp coin MRS delete & spinner
hide_output sg yiimpadmin yiimp coin NBT delete & spinner
hide_output sg yiimpadmin yiimp coin NOXT delete & spinner
hide_output sg yiimpadmin yiimp coin NXTI delete & spinner
hide_output sg yiimpadmin yiimp coin PIGGY delete & spinner
hide_output sg yiimpadmin yiimp coin PRC delete & spinner
hide_output sg yiimpadmin yiimp coin RIC delete & spinner
hide_output sg yiimpadmin yiimp coin SJCX delete & spinner
hide_output sg yiimpadmin yiimp coin SQL delete & spinner
hide_output sg yiimpadmin yiimp coin SRCC delete & spinner
hide_output sg yiimpadmin yiimp coin SWARM delete & spinner
hide_output sg yiimpadmin yiimp coin UNITY delete & spinner
hide_output sg yiimpadmin yiimp coin WOLF delete & spinner
hide_output sg yiimpadmin yiimp coin XWC delete & spinner
hide_output sg yiimpadmin yiimp coin FSC2 delete & spinner
hide_output sg yiimpadmin yiimp coin RBR delete & spinner
hide_output sg yiimpadmin yiimp coin CSD delete & spinner
hide_output sg yiimpadmin yiimp coin XDE delete & spinner
hide_output sg yiimpadmin yiimp coin XPC delete & spinner
hide_output sg yiimpadmin yiimp coin DGD delete & spinner
hide_output sg yiimpadmin yiimp coin ARI delete & spinner
hide_output sg yiimpadmin yiimp coin XBS delete & spinner
hide_output sg yiimpadmin yiimp coin USDT delete & spinner
hide_output sg yiimpadmin yiimp coin GP delete & spinner
hide_output sg yiimpadmin yiimp coin CON delete & spinner
hide_output sg yiimpadmin yiimp coin EAGS delete & spinner
hide_output sg yiimpadmin yiimp coin NKA delete & spinner
hide_output sg yiimpadmin yiimp coin INCA delete & spinner
hide_output sg yiimpadmin yiimp coin XSP delete & spinner
hide_output sg yiimpadmin yiimp coin BCR delete & spinner
hide_output sg yiimpadmin yiimp coin BLK delete & spinner
hide_output sg yiimpadmin yiimp coin SBIT delete & spinner
hide_output sg yiimpadmin yiimp coin UIS delete & spinner
hide_output sg yiimpadmin yiimp coin HGC delete & spinner
hide_output sg yiimpadmin yiimp coin 2015 delete & spinner
hide_output sg yiimpadmin yiimp coin GMC delete & spinner
hide_output sg yiimpadmin yiimp coin VMC delete & spinner
hide_output sg yiimpadmin yiimp coin ggggg delete & spinner
hide_output sg yiimpadmin yiimp coin UCI delete & spinner
hide_output sg yiimpadmin yiimp coin EQX delete & spinner
hide_output sg yiimpadmin yiimp coin TAK delete & spinner
hide_output sg yiimpadmin yiimp coin TEK delete & spinner
hide_output sg yiimpadmin yiimp coin TES delete & spinner
hide_output sg yiimpadmin yiimp coin TGC delete & spinner
hide_output sg yiimpadmin yiimp coin TOR delete & spinner
hide_output sg yiimpadmin yiimp coin TRC delete & spinner
hide_output sg yiimpadmin yiimp coin UNB delete & spinner
hide_output sg yiimpadmin yiimp coin USDe delete & spinner
hide_output sg yiimpadmin yiimp coin XCR delete & spinner
hide_output sg yiimpadmin yiimp coin XJO delete & spinner
hide_output sg yiimpadmin yiimp coin XLB delete & spinner
hide_output sg yiimpadmin yiimp coin YAC delete & spinner
hide_output sg yiimpadmin yiimp coin YBC delete & spinner
hide_output sg yiimpadmin yiimp coin ZCC delete & spinner
hide_output sg yiimpadmin yiimp coin ZED delete & spinner
hide_output sg yiimpadmin yiimp coin ADT delete & spinner
hide_output sg yiimpadmin yiimp coin ASC delete & spinner
hide_output sg yiimpadmin yiimp coin BAT delete & spinner
hide_output sg yiimpadmin yiimp coin COL delete & spinner
hide_output sg yiimpadmin yiimp coin CPR delete & spinner
hide_output sg yiimpadmin yiimp coin CTM delete & spinner
hide_output sg yiimpadmin yiimp coin DBL delete & spinner
hide_output sg yiimpadmin yiimp coin DMC delete & spinner
hide_output sg yiimpadmin yiimp coin ELP delete & spinner
hide_output sg yiimpadmin yiimp coin FLAP delete & spinner
hide_output sg yiimpadmin yiimp coin GME delete & spinner
hide_output sg yiimpadmin yiimp coin LEAF delete & spinner
hide_output sg yiimpadmin yiimp coin LOT delete & spinner
hide_output sg yiimpadmin yiimp coin MEM delete & spinner
hide_output sg yiimpadmin yiimp coin MEOW delete & spinner
hide_output sg yiimpadmin yiimp coin MST delete & spinner
hide_output sg yiimpadmin yiimp coin RBBT delete & spinner
hide_output sg yiimpadmin yiimp coin RED delete & spinner
hide_output sg yiimpadmin yiimp coin TIPS delete & spinner
hide_output sg yiimpadmin yiimp coin TIX delete & spinner
hide_output sg yiimpadmin yiimp coin XNC delete & spinner
hide_output sg yiimpadmin yiimp coin ZEIT delete & spinner
hide_output sg yiimpadmin yiimp coin AC delete & spinner
hide_output sg yiimpadmin yiimp coin Acoin  delete & spinner
hide_output sg yiimpadmin yiimp coin AGS delete & spinner
hide_output sg yiimpadmin yiimp coin ALF delete & spinner
hide_output sg yiimpadmin yiimp coin ALN delete & spinner
hide_output sg yiimpadmin yiimp coin AMC delete & spinner
hide_output sg yiimpadmin yiimp coin ARG delete & spinner
hide_output sg yiimpadmin yiimp coin AUR delete & spinner
hide_output sg yiimpadmin yiimp coin BCX delete & spinner
hide_output sg yiimpadmin yiimp coin BEN delete & spinner
hide_output sg yiimpadmin yiimp coin BET delete & spinner
hide_output sg yiimpadmin yiimp coin BNCR delete & spinner
hide_output sg yiimpadmin yiimp coin BOST delete & spinner
hide_output sg yiimpadmin yiimp coin BQC delete & spinner
hide_output sg yiimpadmin yiimp coin BTB delete & spinner
hide_output sg yiimpadmin yiimp coin BTE delete & spinner
hide_output sg yiimpadmin yiimp coin BTG delete & spinner
hide_output sg yiimpadmin yiimp coin BUK delete & spinner
hide_output sg yiimpadmin yiimp coin CACH delete & spinner
hide_output sg yiimpadmin yiimp coin CAP delete & spinner
hide_output sg yiimpadmin yiimp coin CASH delete & spinner
hide_output sg yiimpadmin yiimp coin CGB delete & spinner
hide_output sg yiimpadmin yiimp coin CINNI delete & spinner
hide_output sg yiimpadmin yiimp coin CMC delete & spinner
hide_output sg yiimpadmin yiimp coin CNC delete & spinner
hide_output sg yiimpadmin yiimp coin CNL delete & spinner
hide_output sg yiimpadmin yiimp coin COMM delete & spinner
hide_output sg yiimpadmin yiimp coin COOL delete & spinner
hide_output sg yiimpadmin yiimp coin CRACK delete & spinner
hide_output sg yiimpadmin yiimp coin CRC delete & spinner
hide_output sg yiimpadmin yiimp coin CSC delete & spinner
hide_output sg yiimpadmin yiimp coin DEM delete & spinner
hide_output sg yiimpadmin yiimp coin DMD delete & spinner
hide_output sg yiimpadmin yiimp coin DRKC delete & spinner
hide_output sg yiimpadmin yiimp coin DT delete & spinner
hide_output sg yiimpadmin yiimp coin DVC delete & spinner
hide_output sg yiimpadmin yiimp coin EAC delete & spinner
hide_output sg yiimpadmin yiimp coin ELC delete & spinner
hide_output sg yiimpadmin yiimp coin EMD delete & spinner
hide_output sg yiimpadmin yiimp coin EZC delete & spinner
hide_output sg yiimpadmin yiimp coin FFC delete & spinner
hide_output sg yiimpadmin yiimp coin FLT delete & spinner
hide_output sg yiimpadmin yiimp coin FRAC delete & spinner
hide_output sg yiimpadmin yiimp coin FRK delete & spinner
hide_output sg yiimpadmin yiimp coin FST delete & spinner
hide_output sg yiimpadmin yiimp coin GDC delete & spinner
hide_output sg yiimpadmin yiimp coin GLC delete & spinner
hide_output sg yiimpadmin yiimp coin GLD delete & spinner
hide_output sg yiimpadmin yiimp coin GLX delete & spinner
hide_output sg yiimpadmin yiimp coin GLYPH delete & spinner
hide_output sg yiimpadmin yiimp coin GUE delete & spinner
hide_output sg yiimpadmin yiimp coin HBN delete & spinner
hide_output sg yiimpadmin yiimp coin HVC delete & spinner
hide_output sg yiimpadmin yiimp coin ICB delete & spinner
hide_output sg yiimpadmin yiimp coin IXC delete & spinner
hide_output sg yiimpadmin yiimp coin JKC delete & spinner
hide_output sg yiimpadmin yiimp coin KDC delete & spinner
hide_output sg yiimpadmin yiimp coin KGC delete & spinner
hide_output sg yiimpadmin yiimp coin LAB delete & spinner
hide_output sg yiimpadmin yiimp coin LGD delete & spinner
hide_output sg yiimpadmin yiimp coin LK7 delete & spinner
hide_output sg yiimpadmin yiimp coin LKY delete & spinner
hide_output sg yiimpadmin yiimp coin LTB delete & spinner
hide_output sg yiimpadmin yiimp coin LTCX delete & spinner
hide_output sg yiimpadmin yiimp coin LYC delete & spinner
hide_output sg yiimpadmin yiimp coin MED delete & spinner
hide_output sg yiimpadmin yiimp coin MNC delete & spinner
hide_output sg yiimpadmin yiimp coin MZC delete & spinner
hide_output sg yiimpadmin yiimp coin NAN delete & spinner
hide_output sg yiimpadmin yiimp coin NBL delete & spinner
hide_output sg yiimpadmin yiimp coin NEC delete & spinner
hide_output sg yiimpadmin yiimp coin NRB delete & spinner
hide_output sg yiimpadmin yiimp coin NRS delete & spinner
hide_output sg yiimpadmin yiimp coin NYAN delete & spinner
hide_output sg yiimpadmin yiimp coin OSC delete & spinner
hide_output sg yiimpadmin yiimp coin PHS delete & spinner
hide_output sg yiimpadmin yiimp coin Points delete & spinner
hide_output sg yiimpadmin yiimp coin PSEUD delete & spinner
hide_output sg yiimpadmin yiimp coin PTS delete & spinner
hide_output sg yiimpadmin yiimp coin PYC delete & spinner
hide_output sg yiimpadmin yiimp coin RT2 delete & spinner
hide_output sg yiimpadmin yiimp coin RYC delete & spinner
hide_output sg yiimpadmin yiimp coin SAT2 delete & spinner
hide_output sg yiimpadmin yiimp coin SBC delete & spinner
hide_output sg yiimpadmin yiimp coin SHLD delete & spinner
hide_output sg yiimpadmin yiimp coin SILK delete & spinner
hide_output sg yiimpadmin yiimp coin SMC delete & spinner
hide_output sg yiimpadmin yiimp coin SOLE delete & spinner
hide_output sg yiimpadmin yiimp coin SPA delete & spinner
hide_output sg yiimpadmin yiimp coin SPT delete & spinner
hide_output sg yiimpadmin yiimp coin SSV delete & spinner
hide_output sg yiimpadmin yiimp coin EMC2 delete & spinner
hide_output sg yiimpadmin yiimp coin GIMP delete & spinner
hide_output sg yiimpadmin yiimp coin GRC delete & spinner
hide_output sg yiimpadmin yiimp coin KRYP delete & spinner
hide_output sg yiimpadmin yiimp coin MIC delete & spinner
hide_output sg yiimpadmin yiimp coin MOTO delete & spinner
hide_output sg yiimpadmin yiimp coin MSC delete & spinner
hide_output sg yiimpadmin yiimp coin NIC delete & spinner
hide_output sg yiimpadmin yiimp coin NWO delete & spinner
hide_output sg yiimpadmin yiimp coin PLCN delete & spinner
hide_output sg yiimpadmin yiimp coin PROZ delete & spinner
hide_output sg yiimpadmin yiimp coin SONG delete & spinner
hide_output sg yiimpadmin yiimp coin SPUDS delete & spinner
hide_output sg yiimpadmin yiimp coin SQC delete & spinner
hide_output sg yiimpadmin yiimp coin VOXP delete & spinner
hide_output sg yiimpadmin yiimp coin VTX delete & spinner
hide_output sg yiimpadmin yiimp coin XRC delete & spinner
hide_output sg yiimpadmin yiimp coin XSX delete & spinner
hide_output sg yiimpadmin yiimp coin XVG delete & spinner
hide_output sg yiimpadmin yiimp coin DON delete & spinner
hide_output sg yiimpadmin yiimp coin FJC delete & spinner
hide_output sg yiimpadmin yiimp coin GCN delete & spinner
hide_output sg yiimpadmin yiimp coin GRN delete & spinner
hide_output sg yiimpadmin yiimp coin GUA delete & spinner
hide_output sg yiimpadmin yiimp coin HAM delete & spinner
hide_output sg yiimpadmin yiimp coin HEX delete & spinner
hide_output sg yiimpadmin yiimp coin IFC delete & spinner
hide_output sg yiimpadmin yiimp coin IRL delete & spinner
hide_output sg yiimpadmin yiimp coin KARM delete & spinner
hide_output sg yiimpadmin yiimp coin MINT delete & spinner
hide_output sg yiimpadmin yiimp coin MOON delete & spinner
hide_output sg yiimpadmin yiimp coin MTLMC delete & spinner
hide_output sg yiimpadmin yiimp coin NMC delete & spinner
hide_output sg yiimpadmin yiimp coin NYC delete & spinner
hide_output sg yiimpadmin yiimp coin ORB delete & spinner
hide_output sg yiimpadmin yiimp coin PCC delete & spinner
hide_output sg yiimpadmin yiimp coin PHC delete & spinner
hide_output sg yiimpadmin yiimp coin RC delete & spinner
hide_output sg yiimpadmin yiimp coin SXC delete & spinner
hide_output sg yiimpadmin yiimp coin TRL delete & spinner
hide_output sg yiimpadmin yiimp coin USD delete & spinner
hide_output sg yiimpadmin yiimp coin VTA delete & spinner
hide_output sg yiimpadmin yiimp coin XPM delete & spinner
hide_output sg yiimpadmin yiimp coin BURST delete & spinner
hide_output sg yiimpadmin yiimp coin LTCD delete & spinner
hide_output sg yiimpadmin yiimp coin CRAIG delete & spinner
hide_output sg yiimpadmin yiimp coin TIT delete & spinner
hide_output sg yiimpadmin yiimp coin BSTY delete & spinner
hide_output sg yiimpadmin yiimp coin GNS delete & spinner
hide_output sg yiimpadmin yiimp coin DCN delete & spinner
hide_output sg yiimpadmin yiimp coin PXI delete & spinner
hide_output sg yiimpadmin yiimp coin ROS delete & spinner
hide_output sg yiimpadmin yiimp coin STV delete & spinner
hide_output sg yiimpadmin yiimp coin OPAL delete & spinner
hide_output sg yiimpadmin yiimp coin EXCL delete & spinner
hide_output sg yiimpadmin yiimp coin PYRA delete & spinner
hide_output sg yiimpadmin yiimp coin NET delete & spinner
hide_output sg yiimpadmin yiimp coin SEED delete & spinner
hide_output sg yiimpadmin yiimp coin PND delete & spinner
hide_output sg yiimpadmin yiimp coin GHC delete & spinner
hide_output sg yiimpadmin yiimp coin DOPE delete & spinner
hide_output sg yiimpadmin yiimp coin ONE delete & spinner
hide_output sg yiimpadmin yiimp coin BLEU delete & spinner
hide_output sg yiimpadmin yiimp coin BVC delete & spinner
hide_output sg yiimpadmin yiimp coin CAGE delete & spinner
hide_output sg yiimpadmin yiimp coin CDN delete & spinner
hide_output sg yiimpadmin yiimp coin CESC delete & spinner
hide_output sg yiimpadmin yiimp coin CLR delete & spinner
hide_output sg yiimpadmin yiimp coin CZC delete & spinner
hide_output sg yiimpadmin yiimp coin CHILD delete & spinner
hide_output sg yiimpadmin yiimp coin XQN delete & spinner
hide_output sg yiimpadmin yiimp coin RDD delete & spinner
hide_output sg yiimpadmin yiimp coin NXT delete & spinner
hide_output sg yiimpadmin yiimp coin BC delete & spinner
hide_output sg yiimpadmin yiimp coin MYR-qubit delete & spinner
hide_output sg yiimpadmin yiimp coin UTC delete & spinner
hide_output sg yiimpadmin yiimp coin 888 delete & spinner
hide_output sg yiimpadmin yiimp coin EFL delete & spinner
hide_output sg yiimpadmin yiimp coin DIME delete & spinner
hide_output sg yiimpadmin yiimp coin SLR delete & spinner
hide_output sg yiimpadmin yiimp coin WATER delete & spinner
hide_output sg yiimpadmin yiimp coin NLG delete & spinner
hide_output sg yiimpadmin yiimp coin GIVE delete & spinner
hide_output sg yiimpadmin yiimp coin WC delete & spinner
hide_output sg yiimpadmin yiimp coin NOBL delete & spinner
hide_output sg yiimpadmin yiimp coin BITS delete & spinner
hide_output sg yiimpadmin yiimp coin BLU delete & spinner
hide_output sg yiimpadmin yiimp coin OC delete & spinner
hide_output sg yiimpadmin yiimp coin THC delete & spinner
hide_output sg yiimpadmin yiimp coin ENRG delete & spinner
hide_output sg yiimpadmin yiimp coin SHIBE delete & spinner
hide_output sg yiimpadmin yiimp coin SFR delete & spinner
hide_output sg yiimpadmin yiimp coin NAUT delete & spinner
hide_output sg yiimpadmin yiimp coin VRC delete & spinner
hide_output sg yiimpadmin yiimp coin CURE delete & spinner
hide_output sg yiimpadmin yiimp coin SYNC delete & spinner
hide_output sg yiimpadmin yiimp coin BLC delete & spinner
hide_output sg yiimpadmin yiimp coin XSI delete & spinner
hide_output sg yiimpadmin yiimp coin XC delete & spinner
hide_output sg yiimpadmin yiimp coin XDQ delete & spinner
hide_output sg yiimpadmin yiimp coin MMXIV delete & spinner
hide_output sg yiimpadmin yiimp coin CAIX delete & spinner
hide_output sg yiimpadmin yiimp coin BBR delete & spinner
hide_output sg yiimpadmin yiimp coin HYPER delete & spinner
hide_output sg yiimpadmin yiimp coin CCN delete & spinner
hide_output sg yiimpadmin yiimp coin KTK delete & spinner
hide_output sg yiimpadmin yiimp coin MUGA delete & spinner
hide_output sg yiimpadmin yiimp coin VOOT delete & spinner
hide_output sg yiimpadmin yiimp coin BN delete & spinner
hide_output sg yiimpadmin yiimp coin XMR delete & spinner
hide_output sg yiimpadmin yiimp coin CLOAK delete & spinner
hide_output sg yiimpadmin yiimp coin CHCC delete & spinner
hide_output sg yiimpadmin yiimp coin BURN delete & spinner
hide_output sg yiimpadmin yiimp coin KORE delete & spinner
hide_output sg yiimpadmin yiimp coin RZR delete & spinner
hide_output sg yiimpadmin yiimp coin XDN delete & spinner
hide_output sg yiimpadmin yiimp coin MIN delete & spinner
hide_output sg yiimpadmin yiimp coin TECH delete & spinner
hide_output sg yiimpadmin yiimp coin GML delete & spinner
hide_output sg yiimpadmin yiimp coin TRK delete & spinner
hide_output sg yiimpadmin yiimp coin WKC delete & spinner
hide_output sg yiimpadmin yiimp coin QTL delete & spinner
hide_output sg yiimpadmin yiimp coin XXX delete & spinner
hide_output sg yiimpadmin yiimp coin AERO delete & spinner
hide_output sg yiimpadmin yiimp coin TRUST delete & spinner
hide_output sg yiimpadmin yiimp coin BRIT delete & spinner
hide_output sg yiimpadmin yiimp coin JUDGE delete & spinner
hide_output sg yiimpadmin yiimp coin NAV delete & spinner
hide_output sg yiimpadmin yiimp coin XST delete & spinner
hide_output sg yiimpadmin yiimp coin APEX delete & spinner
hide_output sg yiimpadmin yiimp coin ZET delete & spinner
hide_output sg yiimpadmin yiimp coin BTCD delete & spinner
hide_output sg yiimpadmin yiimp coin KEY delete & spinner
hide_output sg yiimpadmin yiimp coin NUD delete & spinner
hide_output sg yiimpadmin yiimp coin TRI delete & spinner
hide_output sg yiimpadmin yiimp coin PES delete & spinner
hide_output sg yiimpadmin yiimp coin ICG delete & spinner
hide_output sg yiimpadmin yiimp coin UNO delete & spinner
hide_output sg yiimpadmin yiimp coin ESC delete & spinner
hide_output sg yiimpadmin yiimp coin PINK delete & spinner
hide_output sg yiimpadmin yiimp coin IOC delete & spinner
hide_output sg yiimpadmin yiimp coin SDC delete & spinner
hide_output sg yiimpadmin yiimp coin RAW delete & spinner
hide_output sg yiimpadmin yiimp coin MAX delete & spinner
hide_output sg yiimpadmin yiimp coin LXC delete & spinner
hide_output sg yiimpadmin yiimp coin BOOM delete & spinner
hide_output sg yiimpadmin yiimp coin BOB delete & spinner
hide_output sg yiimpadmin yiimp coin UNAT delete & spinner
hide_output sg yiimpadmin yiimp coin MWC delete & spinner
hide_output sg yiimpadmin yiimp coin VAULT delete & spinner
hide_output sg yiimpadmin yiimp coin FC2 delete & spinner
hide_output sg yiimpadmin yiimp coin SSD delete & spinner
hide_output sg yiimpadmin yiimp coin BIG delete & spinner
hide_output sg yiimpadmin yiimp coin GB delete & spinner
hide_output sg yiimpadmin yiimp coin ROOT delete & spinner
hide_output sg yiimpadmin yiimp coin AXR delete & spinner
hide_output sg yiimpadmin yiimp coin RIPO delete & spinner
hide_output sg yiimpadmin yiimp coin FIBRE delete & spinner
hide_output sg yiimpadmin yiimp coin SHADE delete & spinner
hide_output sg yiimpadmin yiimp coin FLEX delete & spinner
hide_output sg yiimpadmin yiimp coin XBOT delete & spinner
hide_output sg yiimpadmin yiimp coin XCASH delete & spinner
hide_output sg yiimpadmin yiimp coin NKT delete & spinner
hide_output sg yiimpadmin yiimp coin TTC delete & spinner
hide_output sg yiimpadmin yiimp coin CLAM delete & spinner
hide_output sg yiimpadmin yiimp coin VTR delete & spinner
hide_output sg yiimpadmin yiimp coin SUPER delete & spinner
hide_output sg yiimpadmin yiimp coin NOO delete & spinner
hide_output sg yiimpadmin yiimp coin XPY delete & spinner
hide_output sg yiimpadmin yiimp coin SMLY delete & spinner
hide_output sg yiimpadmin yiimp coin BCENT delete & spinner
hide_output sg yiimpadmin yiimp coin DS delete & spinner
hide_output sg yiimpadmin yiimp coin FAIR delete & spinner
hide_output sg yiimpadmin yiimp coin EVENT delete & spinner
hide_output sg yiimpadmin yiimp coin HUC delete & spinner
hide_output sg yiimpadmin yiimp coin CAT delete & spinner
hide_output sg yiimpadmin yiimp coin WDC delete & spinner
hide_output sg yiimpadmin yiimp coin BTM delete & spinner
hide_output sg yiimpadmin yiimp coin RMS delete & spinner
hide_output sg yiimpadmin yiimp coin ANC delete & spinner
hide_output sg yiimpadmin yiimp coin MEC delete & spinner
hide_output sg yiimpadmin yiimp coin MONA delete & spinner
hide_output sg yiimpadmin yiimp coin DGC delete & spinner
hide_output sg yiimpadmin yiimp coin BCF delete & spinner
hide_output sg yiimpadmin yiimp coin SYS delete & spinner
hide_output sg yiimpadmin yiimp coin ULTC delete & spinner
hide_output sg yiimpadmin yiimp coin CXC delete & spinner
hide_output sg yiimpadmin yiimp coin METAL delete & spinner
hide_output sg yiimpadmin yiimp coin SPR delete & spinner
hide_output sg yiimpadmin yiimp coin CBR delete & spinner
hide_output sg yiimpadmin yiimp coin FIND delete & spinner
hide_output sg yiimpadmin yiimp coin AM delete & spinner
hide_output sg yiimpadmin yiimp coin FUD delete & spinner
hide_output sg yiimpadmin yiimp coin ERM delete & spinner
hide_output sg yiimpadmin yiimp coin VIA delete & spinner
hide_output sg yiimpadmin yiimp coin CKC delete & spinner
hide_output sg yiimpadmin yiimp coin BTS delete & spinner
hide_output sg yiimpadmin yiimp coin DEAF delete & spinner
hide_output sg yiimpadmin yiimp coin HIC delete & spinner
hide_output sg yiimpadmin yiimp coin BAY delete & spinner
hide_output sg yiimpadmin yiimp coin VIOR delete & spinner
hide_output sg yiimpadmin yiimp coin VPN delete & spinner
hide_output sg yiimpadmin yiimp coin MN delete & spinner
hide_output sg yiimpadmin yiimp coin EXE delete & spinner
hide_output sg yiimpadmin yiimp coin PFC delete & spinner
hide_output sg yiimpadmin yiimp coin GSX delete & spinner
hide_output sg yiimpadmin yiimp coin BRXv2 delete & spinner
hide_output sg yiimpadmin yiimp coin ACHK delete & spinner
hide_output sg yiimpadmin yiimp coin CRYPT delete & spinner
hide_output sg yiimpadmin yiimp coin HLC delete & spinner
hide_output sg yiimpadmin yiimp coin SWIFT delete & spinner
hide_output sg yiimpadmin yiimp coin ARCH delete & spinner
hide_output sg yiimpadmin yiimp coin GAIA delete & spinner
hide_output sg yiimpadmin yiimp coin WWC delete & spinner
hide_output sg yiimpadmin yiimp coin XRP delete & spinner
hide_output sg yiimpadmin yiimp coin LMR delete & spinner
hide_output sg yiimpadmin yiimp coin MNE delete & spinner
hide_output sg yiimpadmin yiimp coin CRW delete & spinner
hide_output sg yiimpadmin yiimp coin VDO delete & spinner
hide_output sg yiimpadmin yiimp coin NOPE delete & spinner
hide_output sg yiimpadmin yiimp coin XWT delete & spinner
hide_output sg yiimpadmin yiimp coin DTC delete & spinner
hide_output sg yiimpadmin yiimp coin SMBR delete & spinner
hide_output sg yiimpadmin yiimp coin HYP delete & spinner
hide_output sg yiimpadmin yiimp coin QBK delete & spinner
hide_output sg yiimpadmin yiimp coin CENT delete & spinner
hide_output sg yiimpadmin yiimp coin BLOCK delete & spinner
hide_output sg yiimpadmin yiimp coin CATC delete & spinner
hide_output sg yiimpadmin yiimp coin SCSY delete & spinner
hide_output sg yiimpadmin yiimp coin ABY delete & spinner
hide_output sg yiimpadmin yiimp coin BALLS delete & spinner
hide_output sg yiimpadmin yiimp coin QSLV delete & spinner
hide_output sg yiimpadmin yiimp coin U delete & spinner
hide_output sg yiimpadmin yiimp coin BYC delete & spinner
hide_output sg yiimpadmin yiimp coin BUN delete & spinner
hide_output sg yiimpadmin yiimp coin ZER delete & spinner
hide_output sg yiimpadmin yiimp coin ZNY delete & spinner
hide_output sg yiimpadmin yiimp coin MRY delete & spinner
hide_output sg yiimpadmin yiimp coin CANN delete & spinner
hide_output sg yiimpadmin yiimp coin POT delete & spinner
hide_output sg yiimpadmin yiimp coin TAG delete & spinner
hide_output sg yiimpadmin yiimp coin RBY delete & spinner
hide_output sg yiimpadmin yiimp coin NOTE delete & spinner
hide_output sg yiimpadmin yiimp coin LTC delete & spinner
hide_output sg yiimpadmin yiimp coin NVC delete & spinner
hide_output sg yiimpadmin yiimp coin 42 delete & spinner
hide_output sg yiimpadmin yiimp coin JBS delete & spinner
hide_output sg yiimpadmin yiimp coin LSD delete & spinner
hide_output sg yiimpadmin yiimp coin J delete & spinner
hide_output sg yiimpadmin yiimp coin SLG delete & spinner
hide_output sg yiimpadmin yiimp coin VIK delete & spinner
hide_output sg yiimpadmin yiimp coin RPC delete & spinner
hide_output sg yiimpadmin yiimp coin XG delete & spinner
hide_output sg yiimpadmin yiimp coin DP delete & spinner
hide_output sg yiimpadmin yiimp coin MARYJ delete & spinner
hide_output sg yiimpadmin yiimp coin XMG delete & spinner
hide_output sg yiimpadmin yiimp coin RUBLE delete & spinner
hide_output sg yiimpadmin yiimp coin XCLD delete & spinner
hide_output sg yiimpadmin yiimp coin BST delete & spinner
hide_output sg yiimpadmin yiimp coin HNC delete & spinner
hide_output sg yiimpadmin yiimp coin GXG delete & spinner
hide_output sg yiimpadmin yiimp coin BTX delete & spinner
hide_output sg yiimpadmin yiimp coin 007 delete & spinner
hide_output sg yiimpadmin yiimp coin LUX delete & spinner
hide_output sg yiimpadmin yiimp coin ACP delete & spinner
hide_output sg yiimpadmin yiimp coin STR delete & spinner
hide_output sg yiimpadmin yiimp coin PAC delete & spinner
hide_output sg yiimpadmin yiimp coin PPC delete & spinner
hide_output sg yiimpadmin yiimp coin MLS delete & spinner
hide_output sg yiimpadmin yiimp coin FLO delete & spinner
hide_output sg yiimpadmin yiimp coin PTC delete & spinner
hide_output sg yiimpadmin yiimp coin GUN delete & spinner
hide_output sg yiimpadmin yiimp coin DOGE delete & spinner
echo "$GREEN Junk coin removal completed...$COL_RESET"


sudo rm -r $STORAGE_ROOT/yiimp/yiimp_setup
cd $HOME/multipool/yiimp_single
