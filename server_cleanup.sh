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

echo "source /etc/multipool.conf" | hide_output tee -a ~/.bashrc
echo "source $STORAGE_ROOT/yiimp/.prescreens.start.conf" | hide_output tee -a ~/.bashrc
echo -e "$GREEN YiiMP Screens added...$COL_RESET"

exec sudo su -l $USER
echo "Removing junk coins from YiiMP Database, this may take several minutes...$COL_RESET"
hide_output yiimp coin MDT delete & spinner
hide_output yiimp coin FLAX delete & spinner
hide_output yiimp coin CHC delete & spinner
hide_output yiimp coin DRP delete & spinner
hide_output yiimp coin VTC delete & spinner
hide_output yiimp coin FTC delete & spinner
hide_output yiimp coin UFO delete & spinner
hide_output yiimp coin PXC delete & spinner
hide_output yiimp coin HAL delete & spinner
hide_output yiimp coin XAI delete & spinner
hide_output yiimp coin QRK delete & spinner
hide_output yiimp coin MUE delete & spinner
hide_output yiimp coin BOD delete & spinner
hide_output yiimp coin SRC delete & spinner
hide_output yiimp coin BTQ delete & spinner
hide_output yiimp coin GEO delete & spinner
hide_output yiimp coin DGB delete & spinner
hide_output yiimp coin CYP delete & spinner
hide_output yiimp coin IDC delete & spinner
hide_output yiimp coin NEOS delete & spinner
hide_output yiimp coin MYR delete & spinner
hide_output yiimp coin XDC delete & spinner
hide_output yiimp coin SKC delete & spinner
hide_output yiimp coin LOG delete & spinner
hide_output yiimp coin ILM delete & spinner
hide_output yiimp coin START delete & spinner
hide_output yiimp coin URO delete & spinner
hide_output yiimp coin DASH delete & spinner
hide_output yiimp coin BSC delete & spinner
hide_output yiimp coin HEDG delete & spinner
hide_output yiimp coin AMBER delete & spinner
hide_output yiimp coin HTML5 delete & spinner
hide_output yiimp coin ZRC delete & spinner
hide_output	yiimp coin UNF delete & spinner
hide_output	yiimp coin DES delete & spinner
hide_output	yiimp coin KUMA delete & spinner
hide_output	yiimp coin MEME delete & spinner
hide_output	yiimp coin FOOT delete & spinner
hide_output	yiimp coin UMO delete & spinner
hide_output	yiimp coin G3N delete & spinner
hide_output	yiimp coin SHND delete & spinner
hide_output	yiimp coin WHIPPED delete & spinner
hide_output	yiimp coin FLY delete & spinner
hide_output	yiimp coin BUMBA delete & spinner
hide_output	yiimp coin EBG delete & spinner
hide_output	yiimp coin I0C delete & spinner
hide_output	yiimp coin CAPT delete & spinner
hide_output	yiimp coin PAK delete & spinner
hide_output	yiimp coin EUC delete & spinner
hide_output	yiimp coin GRE-OLD delete & spinner
hide_output	yiimp coin PR delete & spinner
hide_output	yiimp coin VGC delete & spinner
hide_output	yiimp coin CFC delete & spinner
hide_output	yiimp coin GAME delete & spinner
hide_output	yiimp coin FONZ delete & spinner
hide_output	yiimp coin DBIC delete & spinner
hide_output	yiimp coin TRUMP delete & spinner
hide_output	yiimp coin JIF delete & spinner
hide_output	yiimp coin EVIL delete & spinner
hide_output	yiimp coin EVO delete & spinner
hide_output	yiimp coin LTCR delete & spinner
hide_output	yiimp coin SANDG delete & spinner
hide_output	yiimp coin RICHX delete & spinner
hide_output	yiimp coin ADZ delete & spinner
hide_output	yiimp coin DGCS delete & spinner
hide_output	yiimp coin BOLI delete & spinner
hide_output	yiimp coin LGBTQ delete & spinner
hide_output	yiimp coin ZOOM delete & spinner
hide_output	yiimp coin YOC delete & spinner
hide_output	yiimp coin SIB delete & spinner
hide_output	yiimp coin OPES delete & spinner
hide_output	yiimp coin NKC delete & spinner
hide_output	yiimp coin MMXVI delete & spinner
hide_output	yiimp coin MBL delete & spinner
hide_output	yiimp coin KNC delete & spinner
hide_output	yiimp coin AR2 delete & spinner
hide_output	yiimp coin AND delete & spinner
hide_output	yiimp coin TROLL delete & spinner
hide_output	yiimp coin DNET delete & spinner
hide_output	yiimp coin DCR delete & spinner
hide_output	yiimp coin EGC delete & spinner
hide_output	yiimp coin MND delete & spinner
hide_output	yiimp coin BNT delete & spinner
hide_output	yiimp coin AMS delete & spinner
hide_output	yiimp coin INFX delete & spinner
hide_output	yiimp coin BSD delete & spinner
hide_output	yiimp coin HTC delete & spinner
hide_output	yiimp coin CZECO delete & spinner
hide_output	yiimp coin EDRC delete & spinner
hide_output	yiimp coin FTP delete & spinner
hide_output	yiimp coin OP delete & spinner
hide_output	yiimp coin CHAI delete & spinner
hide_output	yiimp coin REV delete & spinner
hide_output	yiimp coin PULSE delete & spinner
hide_output	yiimp coin XCT delete & spinner
hide_output	yiimp coin STS delete & spinner
hide_output	yiimp coin EC delete & spinner
hide_output	yiimp coin CYG delete & spinner
hide_output	yiimp coin VAL delete & spinner
hide_output	yiimp coin TBC delete & spinner
hide_output	yiimp coin CRBIT delete & spinner
hide_output	yiimp coin GMX delete & spinner
hide_output	yiimp coin HODL delete & spinner
hide_output	yiimp coin KLC delete & spinner
hide_output	yiimp coin BUZZ delete & spinner
hide_output	yiimp coin ADCN delete & spinner
hide_output	yiimp coin RBIES delete & spinner
hide_output	yiimp coin SEC delete & spinner
hide_output	yiimp coin XID delete & spinner
hide_output	yiimp coin BTCU delete & spinner
hide_output	yiimp coin WARP delete & spinner
hide_output	yiimp coin CPNC delete & spinner
hide_output	yiimp coin HIRE delete & spinner
hide_output	yiimp coin SLS delete & spinner
hide_output	yiimp coin XHI delete & spinner
hide_output	yiimp coin RADS delete & spinner
hide_output	yiimp coin BTP delete & spinner
hide_output	yiimp coin X2 delete & spinner
hide_output	yiimp coin HMP delete & spinner
hide_output	yiimp coin BRONZ delete & spinner
hide_output	yiimp coin RUBIT delete & spinner
hide_output	yiimp coin REP delete & spinner
hide_output	yiimp coin SPL delete & spinner
hide_output	yiimp coin CIONZ delete & spinner
hide_output	yiimp coin SCRT delete & spinner
hide_output	yiimp coin DEUR delete & spinner
hide_output	yiimp coin VOX delete & spinner
hide_output	yiimp coin CLUB delete & spinner
hide_output	yiimp coin SCOT delete & spinner
hide_output	yiimp coin FLOZ delete & spinner
hide_output	yiimp coin STATS delete & spinner
hide_output	yiimp coin HZDOGE delete & spinner
hide_output	yiimp coin WLC delete & spinner
hide_output	yiimp coin BITUSD delete & spinner
hide_output	yiimp coin BITCNY delete & spinner
hide_output	yiimp coin FNX delete & spinner
hide_output	yiimp coin APC delete & spinner
hide_output	yiimp coin XLM delete & spinner
hide_output	yiimp coin AGRS delete & spinner
hide_output	yiimp coin DROP delete & spinner
hide_output	yiimp coin AMP delete & spinner
hide_output	yiimp coin ANTI delete & spinner
hide_output	yiimp coin 1337 delete & spinner
hide_output	yiimp coin TRBO delete & spinner
hide_output	yiimp coin BIC delete & spinner
hide_output	yiimp coin SOIL delete & spinner
hide_output	yiimp coin OMNI delete & spinner
hide_output	yiimp coin CUBE delete & spinner
hide_output	yiimp coin BAC delete & spinner
hide_output	yiimp coin WOP delete & spinner
hide_output	yiimp coin FCT delete & spinner
hide_output	yiimp coin PRT delete & spinner
hide_output	yiimp coin CBIT delete & spinner
hide_output	yiimp coin NEU delete & spinner
hide_output	yiimp coin STEPS delete & spinner
hide_output	yiimp coin EXP delete & spinner
hide_output	yiimp coin BCY delete & spinner
hide_output	yiimp coin PRIME delete & spinner
hide_output	yiimp coin SHF delete & spinner
hide_output	yiimp coin SWING delete & spinner
hide_output	yiimp coin MI delete & spinner
hide_output	yiimp coin MACRO delete & spinner
hide_output	yiimp coin SC delete & spinner
hide_output	yiimp coin GCR delete & spinner
hide_output	yiimp coin MAPC delete & spinner
hide_output	yiimp coin GCC delete & spinner
hide_output	yiimp coin TX delete & spinner
hide_output	yiimp coin ETH delete & spinner
hide_output	yiimp coin CRE delete & spinner
hide_output	yiimp coin AEON delete & spinner
hide_output	yiimp coin GSY delete & spinner
hide_output	yiimp coin CHIP delete & spinner
hide_output	yiimp coin BTCHC delete & spinner
hide_output	yiimp coin AXIOM delete & spinner
hide_output	yiimp coin FUEL delete & spinner
hide_output	yiimp coin BIOS delete & spinner
hide_output	yiimp coin CPC delete & spinner
hide_output	yiimp coin IBITS delete & spinner
hide_output	yiimp coin DIGS delete & spinner
hide_output	yiimp coin NOC delete & spinner
hide_output	yiimp coin MCZ delete & spinner
hide_output	yiimp coin BANX delete & spinner
hide_output	yiimp coin CPN delete & spinner
hide_output	yiimp coin SPRTS delete & spinner
hide_output	yiimp coin SPROUT delete & spinner
hide_output	yiimp coin NUKE delete & spinner
hide_output	yiimp coin 2BACCO delete & spinner
hide_output	yiimp coin FIC delete & spinner
hide_output	yiimp coin LFO delete & spinner
hide_output	yiimp coin VERSA delete & spinner
hide_output	yiimp coin MCAR delete & spinner
hide_output	yiimp coin CARB delete & spinner
hide_output	yiimp coin ZUR delete & spinner
hide_output	yiimp coin VAPE delete & spinner
hide_output	yiimp coin TALK delete & spinner
hide_output	yiimp coin RUM delete & spinner
hide_output	yiimp coin PPCD delete & spinner
hide_output	yiimp coin PHO delete & spinner
hide_output	yiimp coin P0001 delete & spinner
hide_output	yiimp coin NODE delete & spinner
hide_output	yiimp coin MRC delete & spinner
hide_output	yiimp coin ISO delete & spinner
hide_output	yiimp coin HANSA delete & spinner
hide_output	yiimp coin FX01 delete & spinner
hide_output	yiimp coin FRSH delete & spinner
hide_output	yiimp coin FIMK delete & spinner
hide_output	yiimp coin FAIL delete & spinner
hide_output	yiimp coin DRM delete & spinner
hide_output	yiimp coin DRK delete & spinner
hide_output	yiimp coin CV2 delete & spinner
hide_output	yiimp coin BTRHA delete & spinner
hide_output	yiimp coin ALCUREX delete & spinner
hide_output	yiimp coin BNX delete & spinner
hide_output	yiimp coin QUIT delete & spinner
hide_output	yiimp coin V delete & spinner
hide_output	yiimp coin PLC delete & spinner
hide_output	yiimp coin GRW delete & spinner
hide_output	yiimp coin DUO delete & spinner
hide_output	yiimp coin ANI delete & spinner
hide_output	yiimp coin CDC delete & spinner
hide_output	yiimp coin CX delete & spinner
hide_output	yiimp coin MARS delete & spinner
hide_output	yiimp coin SHA delete & spinner
hide_output	yiimp coin FETISH delete & spinner
hide_output	yiimp coin EXC delete & spinner
hide_output	yiimp coin BDSM delete & spinner
hide_output	yiimp coin OFF delete & spinner
hide_output	yiimp coin EMC delete & spinner
hide_output	yiimp coin BLZ delete & spinner
hide_output	yiimp coin CHAO delete & spinner
hide_output	yiimp coin CNO delete & spinner
hide_output	yiimp coin FUNK delete & spinner
hide_output	yiimp coin UNIC delete & spinner
hide_output	yiimp coin DUCK delete & spinner
hide_output	yiimp coin BSY delete & spinner
hide_output	yiimp coin SPN delete & spinner
hide_output	yiimp coin IPC delete & spinner
hide_output	yiimp coin '$MINEZ' delete & spinner
hide_output	yiimp coin '$MINEW' delete & spinner
hide_output	yiimp coin ADD delete & spinner
hide_output	yiimp coin '$MINE' delete & spinner
hide_output	yiimp coin FTCC delete & spinner
hide_output	yiimp coin CIV delete & spinner
hide_output	yiimp coin TOP delete & spinner
hide_output	yiimp coin TTY delete & spinner
hide_output	yiimp coin NTC delete & spinner
hide_output	yiimp coin KIWI delete & spinner
hide_output	yiimp coin XPL delete & spinner
hide_output	yiimp coin XGR delete & spinner
hide_output	yiimp coin '$$$' delete & spinner
hide_output	yiimp coin 66 delete & spinner
hide_output	yiimp coin MDC delete & spinner
hide_output	yiimp coin SVC delete & spinner
hide_output	yiimp coin DARK delete & spinner
hide_output	yiimp coin POP delete & spinner
hide_output	yiimp coin WSX delete & spinner
hide_output	yiimp coin DOT delete & spinner
hide_output	yiimp coin YOVI delete & spinner
hide_output	yiimp coin HXX delete & spinner
hide_output	yiimp coin CRPS delete & spinner
hide_output	yiimp coin BAM delete & spinner
hide_output	yiimp coin SJW delete & spinner
hide_output	yiimp coin GMCX delete & spinner
hide_output	yiimp coin SPX delete & spinner
hide_output	yiimp coin EXT delete & spinner
hide_output	yiimp coin TENNET delete & spinner
hide_output	yiimp coin KC delete & spinner
hide_output	yiimp coin BLUS delete & spinner
hide_output	yiimp coin XRA delete & spinner
hide_output	yiimp coin SPEC delete & spinner
hide_output	yiimp coin EA delete & spinner
hide_output	yiimp coin TAGR delete & spinner
hide_output	yiimp coin HAZE delete & spinner
hide_output	yiimp coin TAM delete & spinner
hide_output	yiimp coin POLY delete & spinner
hide_output	yiimp coin INDEX delete & spinner
hide_output	yiimp coin GENI delete & spinner
hide_output	yiimp coin BUCKS delete & spinner
hide_output	yiimp coin SPKTR delete & spinner
hide_output	yiimp coin GENE delete & spinner
hide_output	yiimp coin GRM delete & spinner
hide_output yiimp coin DIBS delete & spinner
hide_output	yiimp coin GTFO delete & spinner
hide_output	yiimp coin FUTC delete & spinner
hide_output	yiimp coin XVI delete & spinner
hide_output	yiimp coin GLOBE delete & spinner
hide_output	yiimp coin SMSR delete & spinner
hide_output	yiimp coin CIRC delete & spinner
hide_output	yiimp coin WOC2 delete & spinner
hide_output	yiimp coin NODX delete & spinner
hide_output	yiimp coin ERC delete & spinner
hide_output	yiimp coin SEN delete & spinner
hide_output	yiimp coin SAK delete & spinner
hide_output	yiimp coin EOC delete & spinner
hide_output	yiimp coin TRANSF delete & spinner
hide_output	yiimp coin GEN delete & spinner
hide_output	yiimp coin DRKT delete & spinner
hide_output	yiimp coin XCE delete & spinner
hide_output	yiimp coin XPH delete & spinner
hide_output	yiimp coin FIST delete & spinner
hide_output	yiimp coin DUB delete & spinner
hide_output	yiimp coin VAPOR delete & spinner
hide_output	yiimp coin ARPA delete & spinner
hide_output	yiimp coin BNB delete & spinner
hide_output	yiimp coin NANAS delete & spinner
hide_output	yiimp coin SEEDS delete & spinner
hide_output	yiimp coin OPTION delete & spinner
hide_output	yiimp coin DRA delete & spinner
hide_output	yiimp coin GLUCK delete & spinner
hide_output	yiimp coin EXB delete & spinner
hide_output	yiimp coin GREED delete & spinner
hide_output	yiimp coin MOIN delete & spinner
hide_output	yiimp coin Vcoin  delete & spinner
hide_output	yiimp coin TWLV delete & spinner
hide_output	yiimp coin RDN delete & spinner
hide_output	yiimp coin PSY delete & spinner
hide_output	yiimp coin ECC delete & spinner
hide_output	yiimp coin SNRG delete & spinner
hide_output	yiimp coin ADC delete & spinner
hide_output	yiimp coin CREVA delete & spinner
hide_output	yiimp coin VCN delete & spinner
hide_output	yiimp coin 32BIT delete & spinner
hide_output	yiimp coin XNA delete & spinner
hide_output	yiimp coin TWERK delete & spinner
hide_output	yiimp coin CS delete & spinner
hide_output	yiimp coin GENIUS delete & spinner
hide_output	yiimp coin PRE delete & spinner
hide_output	yiimp coin NICE delete & spinner
hide_output	yiimp coin CORG delete & spinner
hide_output	yiimp coin DB delete & spinner
hide_output	yiimp coin EQM delete & spinner
hide_output	yiimp coin FADE delete & spinner
hide_output	yiimp coin SED delete & spinner
hide_output	yiimp coin SKB delete & spinner
hide_output	yiimp coin TNG delete & spinner
hide_output	yiimp coin ARB delete & spinner
hide_output	yiimp coin DCC delete & spinner
hide_output	yiimp coin PTA delete & spinner
hide_output	yiimp coin MRB delete & spinner
hide_output	yiimp coin BTA delete & spinner
hide_output	yiimp coin GRT delete & spinner
hide_output	yiimp coin AST delete & spinner
hide_output	yiimp coin BA delete & spinner
hide_output	yiimp coin KRAK delete & spinner
hide_output	yiimp coin M1 delete & spinner
hide_output	yiimp coin 16BIT delete & spinner
hide_output	yiimp coin TB delete & spinner
hide_output	yiimp coin BIT16 delete & spinner
hide_output	yiimp coin CLV delete & spinner
hide_output	yiimp coin SHELL delete & spinner
hide_output	yiimp coin LIMX delete & spinner
hide_output	yiimp coin BTI delete & spinner
hide_output	yiimp coin FSN delete & spinner
hide_output	yiimp coin TKT delete & spinner
hide_output	yiimp coin FCS delete & spinner
hide_output	yiimp coin VTN delete & spinner
hide_output	yiimp coin EPC delete & spinner
hide_output	yiimp coin PKB delete & spinner
hide_output	yiimp coin GAM delete & spinner
hide_output	yiimp coin ISL delete & spinner
hide_output	yiimp coin VIRAL delete & spinner
hide_output	yiimp coin UTLE delete & spinner
hide_output	yiimp coin PNC delete & spinner
hide_output	yiimp coin GOAT delete & spinner
hide_output	yiimp coin EPY delete & spinner
hide_output	yiimp coin CTO delete & spinner
hide_output	yiimp coin SPC delete & spinner
hide_output	yiimp coin GRAV delete & spinner
hide_output	yiimp coin GPH delete & spinner
hide_output	yiimp coin UNIT delete & spinner
hide_output	yiimp coin BUB delete & spinner
hide_output	yiimp coin TDFB delete & spinner
hide_output	yiimp coin SPHR delete & spinner
hide_output	yiimp coin GUM delete & spinner
hide_output	yiimp coin XMS delete & spinner
hide_output	yiimp coin XSEED delete & spinner
hide_output	yiimp coin XNX delete & spinner
hide_output	yiimp coin XTP delete & spinner
hide_output	yiimp coin DOX delete & spinner
hide_output	yiimp coin QTZ delete & spinner
hide_output	yiimp coin UNAT-skein delete & spinner
hide_output	yiimp coin AIB delete & spinner
hide_output	yiimp coin GRAM delete & spinner
hide_output	yiimp coin SIGU delete & spinner
hide_output	yiimp coin BLITZ delete & spinner
hide_output	yiimp coin NIRO delete & spinner
hide_output	yiimp coin HUGE delete & spinner
hide_output	yiimp coin 7 delete & spinner
hide_output	yiimp coin DRZ delete & spinner
hide_output	yiimp coin UIS-qubit delete & spinner
hide_output	yiimp coin UIS-skein delete & spinner
hide_output	yiimp coin SLING delete & spinner
hide_output	yiimp coin COV delete & spinner
hide_output	yiimp coin NTRN delete & spinner
hide_output	yiimp coin CTK delete & spinner
hide_output	yiimp coin CF delete & spinner
hide_output	yiimp coin CGN delete & spinner
hide_output	yiimp coin OK delete & spinner
hide_output	yiimp coin 8BIT delete & spinner
hide_output	yiimp coin IEC delete & spinner
hide_output	yiimp coin P7C delete & spinner
hide_output	yiimp coin HZT delete & spinner
hide_output	yiimp coin LEA delete & spinner
hide_output	yiimp coin GIZ delete & spinner
hide_output	yiimp coin ETRUST delete & spinner
hide_output	yiimp coin XPRO delete & spinner
hide_output	yiimp coin TRON delete & spinner
hide_output	yiimp coin DECR delete & spinner
hide_output	yiimp coin RICE delete & spinner
hide_output	yiimp coin STP delete & spinner
hide_output	yiimp coin NXE delete & spinner
hide_output	yiimp coin AECC delete & spinner
hide_output	yiimp coin PLANET delete & spinner
hide_output	yiimp coin FIRE delete & spinner
hide_output	yiimp coin ANAL delete & spinner
hide_output	yiimp coin MTLMC3 delete & spinner
hide_output	yiimp coin TWIST delete & spinner
hide_output	yiimp coin CRIME delete & spinner
hide_output	yiimp coin BTCR delete & spinner
hide_output	yiimp coin TEC delete & spinner
hide_output	yiimp coin KARMA delete & spinner
hide_output	yiimp coin TCX delete & spinner
hide_output	yiimp coin TAB delete & spinner
hide_output	yiimp coin NDOGE delete & spinner
hide_output	yiimp coin GIFT delete & spinner
hide_output	yiimp coin BBCC delete & spinner
hide_output	yiimp coin TRICK delete & spinner
hide_output	yiimp coin DGMS delete & spinner
hide_output	yiimp coin CCB delete & spinner
hide_output	yiimp coin OZC delete & spinner
hide_output	yiimp coin STK delete & spinner
hide_output	yiimp coin SIC delete & spinner
hide_output	yiimp coin EGG delete & spinner
hide_output	yiimp coin EKN delete & spinner
hide_output	yiimp coin MRP delete & spinner
hide_output	yiimp coin QORA delete & spinner
hide_output	yiimp coin PXL delete & spinner
hide_output	yiimp coin CRY delete & spinner
hide_output	yiimp coin URC delete & spinner
hide_output	yiimp coin ICN delete & spinner
hide_output	yiimp coin OCTO delete & spinner
hide_output	yiimp coin EUR delete & spinner
hide_output	yiimp coin CAD delete & spinner
hide_output	yiimp coin CC delete & spinner
hide_output	yiimp coin XEM delete & spinner
hide_output	yiimp coin SLFI delete & spinner
hide_output	yiimp coin 256 delete & spinner
hide_output	yiimp coin ICASH delete & spinner
hide_output	yiimp coin BTCRY delete & spinner
hide_output	yiimp coin XDB delete & spinner
hide_output	yiimp coin ZIRK delete & spinner
hide_output	yiimp coin CRAVE delete & spinner
hide_output	yiimp coin BITZ delete & spinner
hide_output	yiimp coin OMC delete & spinner
hide_output	yiimp coin PAY delete & spinner
hide_output	yiimp coin LDOGE delete & spinner
hide_output	yiimp coin RBT delete & spinner
hide_output	yiimp coin ASN delete & spinner
hide_output	yiimp coin MINE delete & spinner
hide_output	yiimp coin XAU delete & spinner
hide_output	yiimp coin XFC delete & spinner
hide_output	yiimp coin UNC delete & spinner
hide_output	yiimp coin XCO delete & spinner
hide_output	yiimp coin VOYA delete & spinner
hide_output	yiimp coin XVC delete & spinner
hide_output	yiimp coin WBB delete & spinner
hide_output	yiimp coin ECASH delete & spinner
hide_output	yiimp coin MTR delete & spinner
hide_output	yiimp coin NSR delete & spinner
hide_output	yiimp coin GSM delete & spinner
hide_output	yiimp coin PTY delete & spinner
hide_output	yiimp coin LYB delete & spinner
hide_output	yiimp coin SUP delete & spinner
hide_output	yiimp coin CIN delete & spinner
hide_output	yiimp coin DD delete & spinner
hide_output	yiimp coin SMAC delete & spinner
hide_output	yiimp coin GRID delete & spinner
hide_output	yiimp coin SLM delete & spinner
hide_output	yiimp coin LTS delete & spinner
hide_output	yiimp coin XTC delete & spinner
hide_output	yiimp coin DGORE delete & spinner
hide_output	yiimp coin BITB delete & spinner
hide_output	yiimp coin BEAN delete & spinner
hide_output	yiimp coin PEN delete & spinner
hide_output	yiimp coin NVCD delete & spinner
hide_output	yiimp coin XPD delete & spinner
hide_output	yiimp coin CBX delete & spinner
hide_output	yiimp coin CELL delete & spinner
hide_output	yiimp coin KOBO delete & spinner
hide_output	yiimp coin LQD delete & spinner
hide_output	yiimp coin XTR delete & spinner
hide_output	yiimp coin 10K delete & spinner
hide_output	yiimp coin MYST delete & spinner
hide_output	yiimp coin BTCS delete & spinner
hide_output	yiimp coin XPB delete & spinner
hide_output	yiimp coin CETI delete & spinner
hide_output	yiimp coin OMA delete & spinner
hide_output	yiimp coin CCC delete & spinner
hide_output	yiimp coin XFB delete & spinner
hide_output	yiimp coin OBS delete & spinner
hide_output	yiimp coin SOON delete & spinner
hide_output	yiimp coin GIG delete & spinner
hide_output	yiimp coin XAP delete & spinner
hide_output	yiimp coin XBC delete & spinner
hide_output	yiimp coin XCH delete & spinner
hide_output	yiimp coin XCN delete & spinner
hide_output	yiimp coin XCP delete & spinner
hide_output	yiimp coin XDP delete & spinner
hide_output	yiimp coin XUSD delete & spinner
hide_output	yiimp coin YACC delete & spinner
hide_output	yiimp coin 1CR delete & spinner
hide_output	yiimp coin ACH delete & spinner
hide_output	yiimp coin ADN delete & spinner
hide_output	yiimp coin BCN delete & spinner
hide_output	yiimp coin BELA delete & spinner
hide_output	yiimp coin C2 delete & spinner
hide_output	yiimp coin CGA delete & spinner
hide_output	yiimp coin CHA delete & spinner
hide_output	yiimp coin CNMT delete & spinner
hide_output	yiimp coin CYC delete & spinner
hide_output	yiimp coin DIEM delete & spinner
hide_output	yiimp coin DSH delete & spinner
hide_output	yiimp coin FLDC delete & spinner
hide_output	yiimp coin GAP delete & spinner
hide_output	yiimp coin GDN delete & spinner
hide_output	yiimp coin GEMZ delete & spinner
hide_output	yiimp coin GOLD delete & spinner
hide_output	yiimp coin GRS delete & spinner
hide_output	yiimp coin HIRO delete & spinner
hide_output	yiimp coin HZ delete & spinner
hide_output	yiimp coin JLH delete & spinner
hide_output	yiimp coin LTBC delete & spinner
hide_output	yiimp coin MAID delete & spinner
hide_output	yiimp coin MCN delete & spinner
hide_output	yiimp coin MIL delete & spinner
hide_output	yiimp coin MMC delete & spinner
hide_output	yiimp coin MMNXT delete & spinner
hide_output	yiimp coin MNTA delete & spinner
hide_output	yiimp coin MRS delete & spinner
hide_output	yiimp coin NBT delete & spinner
hide_output	yiimp coin NOXT delete & spinner
hide_output	yiimp coin NXTI delete & spinner
hide_output	yiimp coin PIGGY delete & spinner
hide_output	yiimp coin PRC delete & spinner
hide_output	yiimp coin RIC delete & spinner
hide_output	yiimp coin SJCX delete & spinner
hide_output	yiimp coin SQL delete & spinner
hide_output	yiimp coin SRCC delete & spinner
hide_output	yiimp coin SWARM delete & spinner
hide_output	yiimp coin UNITY delete & spinner
hide_output	yiimp coin WOLF delete & spinner
hide_output	yiimp coin XWC delete & spinner
hide_output	yiimp coin FSC2 delete & spinner
hide_output	yiimp coin RBR delete & spinner
hide_output	yiimp coin CSD delete & spinner
hide_output	yiimp coin XDE delete & spinner
hide_output	yiimp coin XPC delete & spinner
hide_output	yiimp coin DGD delete & spinner
hide_output	yiimp coin ARI delete & spinner
hide_output	yiimp coin XBS delete & spinner
hide_output	yiimp coin USDT delete & spinner
hide_output	yiimp coin GP delete & spinner
hide_output	yiimp coin CON delete & spinner
hide_output	yiimp coin EAGS delete & spinner
hide_output	yiimp coin NKA delete & spinner
hide_output	yiimp coin INCA delete & spinner
hide_output	yiimp coin XSP delete & spinner
hide_output	yiimp coin BCR delete & spinner
hide_output	yiimp coin BLK delete & spinner
hide_output	yiimp coin SBIT delete & spinner
hide_output	yiimp coin UIS delete & spinner
hide_output	yiimp coin HGC delete & spinner
hide_output	yiimp coin 2015 delete & spinner
hide_output	yiimp coin GMC delete & spinner
hide_output	yiimp coin VMC delete & spinner
hide_output	yiimp coin ggggg delete & spinner
hide_output	yiimp coin UCI delete & spinner
hide_output	yiimp coin EQX delete & spinner
hide_output	yiimp coin TAK delete & spinner
hide_output	yiimp coin TEK delete & spinner
hide_output	yiimp coin TES delete & spinner
hide_output	yiimp coin TGC delete & spinner
hide_output	yiimp coin TOR delete & spinner
hide_output	yiimp coin TRC delete & spinner
hide_output	yiimp coin UNB delete & spinner
hide_output	yiimp coin USDe delete & spinner
hide_output	yiimp coin XCR delete & spinner
hide_output	yiimp coin XJO delete & spinner
hide_output	yiimp coin XLB delete & spinner
hide_output	yiimp coin YAC delete & spinner
hide_output	yiimp coin YBC delete & spinner
hide_output	yiimp coin ZCC delete & spinner
hide_output	yiimp coin ZED delete & spinner
hide_output	yiimp coin ADT delete & spinner
hide_output	yiimp coin ASC delete & spinner
hide_output	yiimp coin BAT delete & spinner
hide_output	yiimp coin COL delete & spinner
hide_output	yiimp coin CPR delete & spinner
hide_output	yiimp coin CTM delete & spinner
hide_output	yiimp coin DBL delete & spinner
hide_output	yiimp coin DMC delete & spinner
hide_output	yiimp coin ELP delete & spinner
hide_output	yiimp coin FLAP delete & spinner
hide_output	yiimp coin GME delete & spinner
hide_output	yiimp coin LEAF delete & spinner
hide_output	yiimp coin LOT delete & spinner
hide_output	yiimp coin MEM delete & spinner
hide_output	yiimp coin MEOW delete & spinner
hide_output	yiimp coin MST delete & spinner
hide_output	yiimp coin RBBT delete & spinner
hide_output	yiimp coin RED delete & spinner
hide_output	yiimp coin TIPS delete & spinner
hide_output	yiimp coin TIX delete & spinner
hide_output	yiimp coin XNC delete & spinner
hide_output	yiimp coin ZEIT delete & spinner
hide_output	yiimp coin AC delete & spinner
hide_output	yiimp coin Acoin  delete & spinner
hide_output	yiimp coin AGS delete & spinner
hide_output	yiimp coin ALF delete & spinner
hide_output	yiimp coin ALN delete & spinner
hide_output	yiimp coin AMC delete & spinner
hide_output	yiimp coin ARG delete & spinner
hide_output	yiimp coin AUR delete & spinner
hide_output	yiimp coin BCX delete & spinner
hide_output	yiimp coin BEN delete & spinner
hide_output	yiimp coin BET delete & spinner
hide_output	yiimp coin BNCR delete & spinner
hide_output	yiimp coin BOST delete & spinner
hide_output	yiimp coin BQC delete & spinner
hide_output	yiimp coin BTB delete & spinner
hide_output	yiimp coin BTE delete & spinner
hide_output	yiimp coin BTG delete & spinner
hide_output	yiimp coin BUK delete & spinner
hide_output	yiimp coin CACH delete & spinner
hide_output	yiimp coin CAP delete & spinner
hide_output	yiimp coin CASH delete & spinner
hide_output	yiimp coin CGB delete & spinner
hide_output	yiimp coin CINNI delete & spinner
hide_output	yiimp coin CMC delete & spinner
hide_output	yiimp coin CNC delete & spinner
hide_output	yiimp coin CNL delete & spinner
hide_output	yiimp coin COMM delete & spinner
hide_output	yiimp coin COOL delete & spinner
hide_output	yiimp coin CRACK delete & spinner
hide_output	yiimp coin CRC delete & spinner
hide_output	yiimp coin CSC delete & spinner
hide_output	yiimp coin DEM delete & spinner
hide_output	yiimp coin DMD delete & spinner
hide_output	yiimp coin DRKC delete & spinner
hide_output	yiimp coin DT delete & spinner
hide_output	yiimp coin DVC delete & spinner
hide_output	yiimp coin EAC delete & spinner
hide_output	yiimp coin ELC delete & spinner
hide_output	yiimp coin EMD delete & spinner
hide_output	yiimp coin EZC delete & spinner
hide_output	yiimp coin FFC delete & spinner
hide_output	yiimp coin FLT delete & spinner
hide_output	yiimp coin FRAC delete & spinner
hide_output	yiimp coin FRK delete & spinner
hide_output	yiimp coin FST delete & spinner
hide_output	yiimp coin GDC delete & spinner
hide_output	yiimp coin GLC delete & spinner
hide_output	yiimp coin GLD delete & spinner
hide_output	yiimp coin GLX delete & spinner
hide_output	yiimp coin GLYPH delete & spinner
hide_output	yiimp coin GUE delete & spinner
hide_output	yiimp coin HBN delete & spinner
hide_output	yiimp coin HVC delete & spinner
hide_output	yiimp coin ICB delete & spinner
hide_output	yiimp coin IXC delete & spinner
hide_output	yiimp coin JKC delete & spinner
hide_output	yiimp coin KDC delete & spinner
hide_output	yiimp coin KGC delete & spinner
hide_output	yiimp coin LAB delete & spinner
hide_output	yiimp coin LGD delete & spinner
hide_output	yiimp coin LK7 delete & spinner
hide_output	yiimp coin LKY delete & spinner
hide_output	yiimp coin LTB delete & spinner
hide_output	yiimp coin LTCX delete & spinner
hide_output	yiimp coin LYC delete & spinner
hide_output	yiimp coin MED delete & spinner
hide_output	yiimp coin MNC delete & spinner
hide_output	yiimp coin MZC delete & spinner
hide_output	yiimp coin NAN delete & spinner
hide_output	yiimp coin NBL delete & spinner
hide_output	yiimp coin NEC delete & spinner
hide_output	yiimp coin NRB delete & spinner
hide_output	yiimp coin NRS delete & spinner
hide_output	yiimp coin NYAN delete & spinner
hide_output	yiimp coin OSC delete & spinner
hide_output	yiimp coin PHS delete & spinner
hide_output	yiimp coin Points delete & spinner
hide_output	yiimp coin PSEUD delete & spinner
hide_output	yiimp coin PTS delete & spinner
hide_output	yiimp coin PYC delete & spinner
hide_output	yiimp coin RT2 delete & spinner
hide_output	yiimp coin RYC delete & spinner
hide_output	yiimp coin SAT2 delete & spinner
hide_output	yiimp coin SBC delete & spinner
hide_output	yiimp coin SHLD delete & spinner
hide_output	yiimp coin SILK delete & spinner
hide_output	yiimp coin SMC delete & spinner
hide_output	yiimp coin SOLE delete & spinner
hide_output	yiimp coin SPA delete & spinner
hide_output	yiimp coin SPT delete & spinner
hide_output	yiimp coin SSV delete & spinner
hide_output	yiimp coin EMC2 delete & spinner
hide_output	yiimp coin GIMP delete & spinner
hide_output	yiimp coin GRC delete & spinner
hide_output	yiimp coin KRYP delete & spinner
hide_output	yiimp coin MIC delete & spinner
hide_output	yiimp coin MOTO delete & spinner
hide_output	yiimp coin MSC delete & spinner
hide_output	yiimp coin NIC delete & spinner
hide_output	yiimp coin NWO delete & spinner
hide_output	yiimp coin PLCN delete & spinner
hide_output	yiimp coin PROZ delete & spinner
hide_output	yiimp coin SONG delete & spinner
hide_output	yiimp coin SPUDS delete & spinner
hide_output	yiimp coin SQC delete & spinner
hide_output	yiimp coin VOXP delete & spinner
hide_output	yiimp coin VTX delete & spinner
hide_output	yiimp coin XRC delete & spinner
hide_output	yiimp coin XSX delete & spinner
hide_output	yiimp coin XVG delete & spinner
hide_output	yiimp coin DON delete & spinner
hide_output	yiimp coin FJC delete & spinner
hide_output	yiimp coin GCN delete & spinner
hide_output	yiimp coin GRN delete & spinner
hide_output	yiimp coin GUA delete & spinner
hide_output	yiimp coin HAM delete & spinner
hide_output	yiimp coin HEX delete & spinner
hide_output	yiimp coin IFC delete & spinner
hide_output	yiimp coin IRL delete & spinner
hide_output	yiimp coin KARM delete & spinner
hide_output	yiimp coin MINT delete & spinner
hide_output	yiimp coin MOON delete & spinner
hide_output	yiimp coin MTLMC delete & spinner
hide_output	yiimp coin NMC delete & spinner
hide_output	yiimp coin NYC delete & spinner
hide_output	yiimp coin ORB delete & spinner
hide_output	yiimp coin PCC delete & spinner
hide_output	yiimp coin PHC delete & spinner
hide_output	yiimp coin RC delete & spinner
hide_output	yiimp coin SXC delete & spinner
hide_output	yiimp coin TRL delete & spinner
hide_output	yiimp coin USD delete & spinner
hide_output	yiimp coin VTA delete & spinner
hide_output	yiimp coin XPM delete & spinner
hide_output	yiimp coin BURST delete & spinner
hide_output	yiimp coin LTCD delete & spinner
hide_output	yiimp coin CRAIG delete & spinner
hide_output	yiimp coin TIT delete & spinner
hide_output	yiimp coin BSTY delete & spinner
hide_output	yiimp coin GNS delete & spinner
hide_output	yiimp coin DCN delete & spinner
hide_output	yiimp coin PXI delete & spinner
hide_output	yiimp coin ROS delete & spinner
hide_output	yiimp coin STV delete & spinner
hide_output	yiimp coin OPAL delete & spinner
hide_output	yiimp coin EXCL delete & spinner
hide_output	yiimp coin PYRA delete & spinner
hide_output	yiimp coin NET delete & spinner
hide_output	yiimp coin SEED delete & spinner
hide_output	yiimp coin PND delete & spinner
hide_output	yiimp coin GHC delete & spinner
hide_output	yiimp coin DOPE delete & spinner
hide_output	yiimp coin ONE delete & spinner
hide_output	yiimp coin BLEU delete & spinner
hide_output	yiimp coin BVC delete & spinner
hide_output	yiimp coin CAGE delete & spinner
hide_output	yiimp coin CDN delete & spinner
hide_output	yiimp coin CESC delete & spinner
hide_output	yiimp coin CLR delete & spinner
hide_output	yiimp coin CZC delete & spinner
hide_output	yiimp coin CHILD delete & spinner
hide_output	yiimp coin XQN delete & spinner
hide_output	yiimp coin RDD delete & spinner
hide_output	yiimp coin NXT delete & spinner
hide_output	yiimp coin BC delete & spinner
hide_output	yiimp coin MYR-qubit delete & spinner
hide_output	yiimp coin UTC delete & spinner
hide_output	yiimp coin 888 delete & spinner
hide_output	yiimp coin EFL delete & spinner
hide_output	yiimp coin DIME delete & spinner
hide_output	yiimp coin SLR delete & spinner
hide_output	yiimp coin WATER delete & spinner
hide_output	yiimp coin NLG delete & spinner
hide_output	yiimp coin GIVE delete & spinner
hide_output	yiimp coin WC delete & spinner
hide_output	yiimp coin NOBL delete & spinner
hide_output	yiimp coin BITS delete & spinner
hide_output	yiimp coin BLU delete & spinner
hide_output	yiimp coin OC delete & spinner
hide_output	yiimp coin THC delete & spinner
hide_output	yiimp coin ENRG delete & spinner
hide_output	yiimp coin SHIBE delete & spinner
hide_output	yiimp coin SFR delete & spinner
hide_output	yiimp coin NAUT delete & spinner
hide_output	yiimp coin VRC delete & spinner
hide_output	yiimp coin CURE delete & spinner
hide_output	yiimp coin SYNC delete & spinner
hide_output	yiimp coin BLC delete & spinner
hide_output	yiimp coin XSI delete & spinner
hide_output	yiimp coin XC delete & spinner
hide_output	yiimp coin XDQ delete & spinner
hide_output	yiimp coin MMXIV delete & spinner
hide_output	yiimp coin CAIX delete & spinner
hide_output	yiimp coin BBR delete & spinner
hide_output	yiimp coin HYPER delete & spinner
hide_output	yiimp coin CCN delete & spinner
hide_output	yiimp coin KTK delete & spinner
hide_output	yiimp coin MUGA delete & spinner
hide_output	yiimp coin VOOT delete & spinner
hide_output	yiimp coin BN delete & spinner
hide_output	yiimp coin XMR delete & spinner
hide_output	yiimp coin CLOAK delete & spinner
hide_output	yiimp coin CHCC delete & spinner
hide_output	yiimp coin BURN delete & spinner
hide_output	yiimp coin KORE delete & spinner
hide_output	yiimp coin RZR delete & spinner
hide_output	yiimp coin XDN delete & spinner
hide_output	yiimp coin MIN delete & spinner
hide_output	yiimp coin TECH delete & spinner
hide_output	yiimp coin GML delete & spinner
hide_output	yiimp coin TRK delete & spinner
hide_output	yiimp coin WKC delete & spinner
hide_output	yiimp coin QTL delete & spinner
hide_output	yiimp coin XXX delete & spinner
hide_output	yiimp coin AERO delete & spinner
hide_output	yiimp coin TRUST delete & spinner
hide_output	yiimp coin BRIT delete & spinner
hide_output	yiimp coin JUDGE delete & spinner
hide_output	yiimp coin NAV delete & spinner
hide_output	yiimp coin XST delete & spinner
hide_output	yiimp coin APEX delete & spinner
hide_output	yiimp coin ZET delete & spinner
hide_output	yiimp coin BTCD delete & spinner
hide_output	yiimp coin KEY delete & spinner
hide_output	yiimp coin NUD delete & spinner
hide_output	yiimp coin TRI delete & spinner
hide_output	yiimp coin PES delete & spinner
hide_output	yiimp coin ICG delete & spinner
hide_output	yiimp coin UNO delete & spinner
hide_output	yiimp coin ESC delete & spinner
hide_output	yiimp coin PINK delete & spinner
hide_output	yiimp coin IOC delete & spinner
hide_output	yiimp coin SDC delete & spinner
hide_output	yiimp coin RAW delete & spinner
hide_output	yiimp coin MAX delete & spinner
hide_output	yiimp coin LXC delete & spinner
hide_output	yiimp coin BOOM delete & spinner
hide_output	yiimp coin BOB delete & spinner
hide_output	yiimp coin UNAT delete & spinner
hide_output	yiimp coin MWC delete & spinner
hide_output	yiimp coin VAULT delete & spinner
hide_output	yiimp coin FC2 delete & spinner
hide_output	yiimp coin SSD delete & spinner
hide_output	yiimp coin BIG delete & spinner
hide_output	yiimp coin GB delete & spinner
hide_output	yiimp coin ROOT delete & spinner
hide_output	yiimp coin AXR delete & spinner
hide_output	yiimp coin RIPO delete & spinner
hide_output	yiimp coin FIBRE delete & spinner
hide_output	yiimp coin SHADE delete & spinner
hide_output	yiimp coin FLEX delete & spinner
hide_output	yiimp coin XBOT delete & spinner
hide_output	yiimp coin XCASH delete & spinner
hide_output	yiimp coin NKT delete & spinner
hide_output	yiimp coin TTC delete & spinner
hide_output	yiimp coin CLAM delete & spinner
hide_output	yiimp coin VTR delete & spinner
hide_output	yiimp coin SUPER delete & spinner
hide_output	yiimp coin NOO delete & spinner
hide_output	yiimp coin XPY delete & spinner
hide_output	yiimp coin SMLY delete & spinner
hide_output	yiimp coin BCENT delete & spinner
hide_output	yiimp coin DS delete & spinner
hide_output	yiimp coin FAIR delete & spinner
hide_output	yiimp coin EVENT delete & spinner
hide_output	yiimp coin HUC delete & spinner
hide_output	yiimp coin CAT delete & spinner
hide_output	yiimp coin WDC delete & spinner
hide_output	yiimp coin BTM delete & spinner
hide_output	yiimp coin RMS delete & spinner
hide_output	yiimp coin ANC delete & spinner
hide_output	yiimp coin MEC delete & spinner
hide_output	yiimp coin MONA delete & spinner
hide_output	yiimp coin DGC delete & spinner
hide_output	yiimp coin BCF delete & spinner
hide_output	yiimp coin SYS delete & spinner
hide_output	yiimp coin ULTC delete & spinner
hide_output	yiimp coin CXC delete & spinner
hide_output	yiimp coin METAL delete & spinner
hide_output	yiimp coin SPR delete & spinner
hide_output	yiimp coin CBR delete & spinner
hide_output	yiimp coin FIND delete & spinner
hide_output	yiimp coin AM delete & spinner
hide_output	yiimp coin FUD delete & spinner
hide_output	yiimp coin ERM delete & spinner
hide_output	yiimp coin VIA delete & spinner
hide_output	yiimp coin CKC delete & spinner
hide_output	yiimp coin BTS delete & spinner
hide_output	yiimp coin DEAF delete & spinner
hide_output	yiimp coin HIC delete & spinner
hide_output	yiimp coin BAY delete & spinner
hide_output	yiimp coin VIOR delete & spinner
hide_output	yiimp coin VPN delete & spinner
hide_output	yiimp coin MN delete & spinner
hide_output	yiimp coin EXE delete & spinner
hide_output	yiimp coin PFC delete & spinner
hide_output	yiimp coin GSX delete & spinner
hide_output	yiimp coin BRXv2 delete & spinner
hide_output	yiimp coin ACHK delete & spinner
hide_output	yiimp coin CRYPT delete & spinner
hide_output	yiimp coin HLC delete & spinner
hide_output	yiimp coin SWIFT delete & spinner
hide_output	yiimp coin ARCH delete & spinner
hide_output	yiimp coin GAIA delete & spinner
hide_output	yiimp coin WWC delete & spinner
hide_output	yiimp coin XRP delete & spinner
hide_output	yiimp coin LMR delete & spinner
hide_output	yiimp coin MNE delete & spinner
hide_output	yiimp coin CRW delete & spinner
hide_output	yiimp coin VDO delete & spinner
hide_output	yiimp coin NOPE delete & spinner
hide_output	yiimp coin XWT delete & spinner
hide_output	yiimp coin DTC delete & spinner
hide_output	yiimp coin SMBR delete & spinner
hide_output	yiimp coin HYP delete & spinner
hide_output	yiimp coin QBK delete & spinner
hide_output	yiimp coin CENT delete & spinner
hide_output	yiimp coin BLOCK delete & spinner
hide_output	yiimp coin CATC delete & spinner
hide_output	yiimp coin SCSY delete & spinner
hide_output	yiimp coin ABY delete & spinner
hide_output	yiimp coin BALLS delete & spinner
hide_output	yiimp coin QSLV delete & spinner
hide_output	yiimp coin U delete & spinner
hide_output	yiimp coin BYC delete & spinner
hide_output	yiimp coin BUN delete & spinner
hide_output	yiimp coin ZER delete & spinner
hide_output	yiimp coin ZNY delete & spinner
hide_output	yiimp coin MRY delete & spinner
hide_output	yiimp coin CANN delete & spinner
hide_output	yiimp coin POT delete & spinner
hide_output	yiimp coin TAG delete & spinner
hide_output	yiimp coin RBY delete & spinner
hide_output	yiimp coin NOTE delete & spinner
hide_output	yiimp coin LTC delete & spinner
hide_output	yiimp coin NVC delete & spinner
hide_output	yiimp coin 42 delete & spinner
hide_output	yiimp coin JBS delete & spinner
hide_output	yiimp coin LSD delete & spinner
hide_output	yiimp coin J delete & spinner
hide_output	yiimp coin SLG delete & spinner
hide_output	yiimp coin VIK delete & spinner
hide_output	yiimp coin RPC delete & spinner
hide_output	yiimp coin XG delete & spinner
hide_output	yiimp coin DP delete & spinner
hide_output	yiimp coin MARYJ delete & spinner
hide_output	yiimp coin XMG delete & spinner
hide_output	yiimp coin RUBLE delete & spinner
hide_output	yiimp coin XCLD delete & spinner
hide_output	yiimp coin BST delete & spinner
hide_output	yiimp coin HNC delete & spinner
hide_output	yiimp coin GXG delete & spinner
hide_output	yiimp coin BTX delete & spinner
hide_output	yiimp coin 007 delete & spinner
hide_output	yiimp coin LUX delete & spinner
hide_output	yiimp coin ACP delete & spinner
hide_output	yiimp coin STR delete & spinner
hide_output	yiimp coin PAC delete & spinner
hide_output	yiimp coin PPC delete & spinner
hide_output	yiimp coin MLS delete & spinner
hide_output	yiimp coin FLO delete & spinner
hide_output	yiimp coin PTC delete & spinner
hide_output	yiimp coin GUN delete & spinner
hide_output	yiimp coin DOGE delete & spinner
echo "$GREEN Junk coin removal completed...$COL_RESET"


sudo rm -r $STORAGE_ROOT/yiimp/yiimp_setup
cd $HOME/multipool/yiimp_single
