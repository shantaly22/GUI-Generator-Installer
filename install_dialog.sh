#!/bin/bash

#
#Author: Ahmed El Shantaly
#Date: April 3, 2015
#

tput clear
tput setaf 2
tput rev
echo "<<<<<<<<<<<<<<<<Dialogc Installer>>>>>>>>>>>>>>>>"
echo "         Developed by Ahmed El Shantaly          "
echo "              Date: April 3, 2015                " 
echo "-------------------------------------------------"

tput sgr0
build=0
install=0
doneBuild=0
found=0
made=0
THIS=`pwd`/$0

#Checks user command-line flags and sets flags to do what is asked
case $1 in
	"--build" )
		build=1;;
	"--install" )
		install=1;;
	"")
		build=1 install=1;;
	*)
		echo "Invalid Input"
esac

case $2 in
	"--build" )
		build=1;;
	"--install" )
		install=1;;

esac

tput setaf 6

#If build flag is on then its starts to build
if [[ build -eq 1 ]]; then
	echo "Building..."
	echo "Extracting file into `pwd` Would you like to proceed? (yes/no)"
	read proceed
	case $proceed in
		"no" )
			exit 0;;
		"yes" )
			# searches for the line number where finish the script and start the tar.gz
			# take the tarfile and pipe it into tar
			echo "Unpacking..."
			SKIP=`awk '/^__TARFILE_FOLLOWS__/ { print NR + 1; exit 0; }' $0`
			THIS=`pwd`/$0
			tail -n +$SKIP $THIS | tar -xz
			echo "Unpacked Successfully"
			#Option to change default config options
			echo "Would you like to change the Java compiler, compiler arguments, Java Run-Time, and Run-Time arguments? (yes/no)"
			read change
			case $change in
				"no" );;
				"yes" )
					echo "Set default Java compiler:"
					read javaC
					echo "Set default compiler arguments:"
					read comArgs
					echo "Set default Java Run-Time:"
					read jrt
					echo "Set default Run-Time arguments:"
					read rtArgs
					echo "Setting Defaults..."
					$(sed -i "s/private String compilerPath = \"\/usr\/bin\/javac\";/private String compilerPath = \"$javaC\";/g" Definitions.java)					
					$(sed -i "s/private String compilerOptions = \"\";/private String compilerOptions = \"$comArgs\";/g" Definitions.java)					
					$(sed -i "s/private String runTimePath = \"\/usr\/bin\/java\";/private String runTimePath = \"$jrt\";/g" Definitions.java)					
					$(sed -i "s/private String runTimeOptions = \"\";/private String runTimeOptions = \"$rtArgs\";/g" Definitions.java)
					echo "Defaults Set Successfully"		
					;;
				*)
					echo "Invalid Input"
			esac
			#compiles the extracted files
			echo "Compiling System"
			make > /dev/null
			completed=$?
			#checks if build is successful
			if [[ completed -eq 0 ]]; then
				doneBuild=1
				touch Made.tmp
			else
				echo "Build Failed"
				doneBuild=0
				rm -f Made.tmp
			fi
			;;
		*)
			echo "Invalid Input"
	esac
fi

#checks if build is present
if [[ doneBuild -eq 0 ]]; then
	if [[ -e "Made.tmp" ]]; then
		doneBuild=1
	fi	
fi
tput sgr0

tput setaf 3
#If install flag is on starts to install system
if [[ install -eq 1 ]]; then
	if [[ doneBuild -eq 1 ]]; then
		echo "Installing..."
		#Gets directory and checks if it exists, if it doesnt it prompts the user to create it.
		echo "Where would you like to install the program? Leave empty for current directory "
		tput setaf 8
		read directory
		tput setaf 3
		
		if [[ -z $directory ]]; then
			directory=`pwd`
			echo $directory
		fi

		if [[ -d "$directory" ]]; then
			found=1
		else
			echo "Directory not found. Would you like to create it? (yes/no)"
			read create
			case $create in
				"no" )
					found=0
					exit 0;;
				"yes" )
					found=1
					mkdir -p $directory
					echo "Directory Created";;
				*)
					echo "Invalid Input"
			esac
		fi
		#Moves the files to bin and lib directories. Checks for permission to write to file
		if [[ found -eq 1 ]]; then
			if [[ -w "$directory" ]]; then
				echo "Creating $directory/bin Directory"
				mkdir -p $directory/bin
				mv *.class $directory/bin
				mv yadc $directory/bin
				mv icons $directory/bin
				echo "Creating $directory/lib Directory"
				mkdir -p $directory/lib
				mv *.so $directory/lib
				rm -f Made.tmp
				made=1
			else
				echo "PERMISSION DENIED"
				made=0
			fi
		fi
		#Prompts the user if they want to change the .bashrc file.
		if [[ $made -eq 1 ]]; then
			bashrcPath=$(find ~ -name ".bashrc")
			if [[ -e $bashrcPath ]]; then
				echo "Performing changes to .bashrc file would you like to proceed? (yes/no)"
				read create
				case $create in
					"no" ) ;;
					"yes" )
						if [[ ! -w $bashrcPath ]]; then
							chmod 644 $bashrcPath
						fi
						value=$(grep -ic "export LD_LIBRARY_PATH=" ~/.bashrc)
						if [[ $value -eq 1 ]]; then
							$(sed --in-place '/export LD_LIBRARY_PATH=/d' ~/.bashrc)
						fi
						
						echo -e "\n"export LD_LIBRARY_PATH=$directory/lib >> $bashrcPath

						echo "Changes made to .bashrc file";;
					*)
						echo "Invalid Input"
				esac
			else
				echo "Error! .bashrc file not found"
			fi
		fi

		#cleans files if installation is successful
		if [[ $made -eq 1 ]]; then
			echo "Cleaning Files"
			make clean > /dev/null
			echo "Installing Complete"
		else
			echo "Installing Failed"
		fi
		
	else
		echo "No Build Present"
		echo "Exiting..."
	fi
	tput sgr0
	exec bash
fi

tput sgr0
exit 0

__TARFILE_FOLLOWS__
� �TU �=ml�u4��H�AZ�`�I��)Q�T5>�'�2E�$%��by�G���{��y�٦(��Am�@�|4��I�8�m���J�4��.Z#Ei�~ E?�E��7����GQ��p ��f޼y���{o���L�6}ӱ��=�E}�*����>^���g}�^����c�����ڡ���x����FH�jO}��]BFt���u�O��ۆ����kAԵK�����]�i�w�6iZd	��[�љ�#�vx|��უS��0=״�x����G�g��]��Ɂѽ�GGG���;J��U���"#��Zf��,���T(y��Q���&.Bcd�wM{���nϴwA���1R����������U:�Ug�ǰC55�۷�ͮ�ĝY#����I��ʬ[A׶"���OJ}�+���wm⯛^U���B�8�y9X6�ŐQi�$^C^��ƭ���y��)S����U���2��v�Ё�\�;t�?؁]�M����s\��$U�
���h"˸��Ӊ�؆_=�8����UY]=R�LVV9|n`��m`�^e�����2���V{��_�fM�7�*:�{[��A�'�;Bs�=�w�����5\W ^EӰ���6��D��mJP����i�!��Ե=r��@n�M�4Z��Ew+$΀��%��b�V{: !��恺7�bwu�M,�60�V�8�~َ�l����nDovf����@�h&��tcqe���� ~��gV:73�<
����͙��� y�@/�N-�a�c�}=Flc��k壜A�
�O��賨���M������	�(�*�.
�\O+!l�|4	<�]ҙH	3�dfT��v��fTZ�/�J��S�ᩫ���Q����'�an)�"w�Ԍ�Q^���v[�j���U�qJ�Mp� ���c��u��=��t*�N��e�,%�8	��8 ����J�7���Qq9�Q� S�k�|�$��s��� J4KN;m�P,��=��}�>�:���268D� �����0b����J�Zif��>�2"��譖ɬ�y�X��	�(D�j��Qa2�
��b,��s҇j=^��RN�ƪ�W��-�E�.;��:�矼.���"mW_[�W�y��4�a/T��%x���H��8_�J�e����˦o���E�Uh�#j��N��r
����,_���ć/�6UҜs�D�����q4K-ױ,d��W�����bM����7���3��a�F{}S���E�o���T3Kͩxw������t���*@v�n��-�i~�ve-���G�)��`� LU�u��²�T�7t�t���1)Q��5� ^
5�z�ѻ����/M�v˰JR�2����+������F��IFX��Jy��#%�3`50�T-��"vCL�:eg-2H���c�IW7m�a֡�]&a�E��k}�$��	
���5=���}!F[BKOR��
'�̐U�"Nu�ja��$ף�
 d�?���j��h		��=�8%^R���K��Ѩ�^�y�|���}˟��ʀ��:���3թ�����陹�+�s+���KM���n�3���!�4��i�h3��/��tn�rl�����hT�c8��nѰ���hv߲$�p-Q-�f`M�j��6��ԍ�Ɨ%�������tPI�ɜ�(��pr��9ٜ[n.J��h�E&)R-���}�K����Y��To]X�nk��8�M�,7U�k �|٬���E��aQyld�mM;�y���xf�yL��&Y�����̝�sˍٕ�������`L��w,ɢ�}�pA�dc>�\\��T㍳Kn��-�.I��Vt�����Z��r����&������ACt�TV�	M��\[��!�$�B�y���n��'ٻ�ƶ`D�jb�"Y%\a�j[ a�莌\)����n(��c��^�v�#tQAx�h��U���p����4�%SJ,L �
�)� �B]�.KzI�S�a�B*��� ��#�B*
�a��^@$� ��h�~�h��n3��8�?��N,�4D[={�ʉz�$�X���̉�Ӎ��H9��$alx(�w������v���AefI884	ܵan�<�N1A
%�u2U9('YcJ �3D�_x'�814e�w��CW6��q���.��j
k�A��eZi�L���L�._b���h. �_ 6�IA���Zz���Abn�>0;i+k�S��N2�ɔDj��y�)����G
�32�u�l�Sh����Xc	��Ψ���Đ�LFlÀR+�&�UAr��ܭ�	-H-��p�#��X�>��Fp�I�;���������EQvWX����I�u2���A#�I�n�o<���r�NҺ�߼Ze��[�4W���~��Y�H;��f��~��¢�34�<ĸ�`��y�3�(�n]{����?w���6����;�ނ�Xk�-�̬b�'��44�]���}u���M��Q2u:���-�C~�_�}�=Ko,�D�l�}����{-��B��`E����ㄤi�8÷̮�F��*b�A�
E��LX6{4*@Z>���M�uM��q��l7��Ⱦ�9�^�.�B>�Y�e����W��F4lcxN�m��]�9�)�a:�]i<Yy�&F:��_��II¦j��6v�tvS/�H�L�򏐜`+�E� "�K���#�E�'��bmҾ�G#@K�k�j�n�R�[0�ĘQ��`��ar a@`rR�
=/��Z��@���i�'ֺ��T��t�'J趨iW)�I������-ʎ��, �aE���1m�p�3���Z�@b�)��=[<��F��:�a�lj��1(
�č�/2Q��u.�Q���5�}P�EH�Q�I�E���0�,���9JzA�3���2�Y2E�$��@]��0��`��X�w�3+�j��/���^��
���V�{�����d�N����z9
Bg�=�`^ө�sډ�"�'\0����BE4DKi�@B	a"�� &��Ɖ�h�8Ud`uY}ǈ`؏�:y�"~������9D��i�x������UI��EZR?n�M7F)A�Ez�(-���ؤ�jB��CJ���9�\X�
A�3�?�+!KY��M���%%��ae��|���墸L�����-9(&��U�
�QM���J��P�`Q�7�&��ICo��@��π%K��N����fˠ�%bl�m�����٣�ӆ�û]�c*`�һ���!�W�k[$E�"�ɗ(��OJ�1ê���3��@��P��o4��<DJ�1��C�hx"�u�;7D�r;5D�[
ו&���a�Jt1�2]ѹgY����{�'����AU��걬Z%�LU�n�����M�r�T1���7�H�Mϝw���3�k�8�E�dȊ�FU>�Q5�S�Z���*
����Z��/ݵM7�쫝9|]
�w/=�H��+�/�$;vj�S56a
�i��Q�����(����%��ʟ�v
�o��K��W��tz( #�t/ yn}�ltaOj�c�s�h�]��T�����wgl��b����8�N�&�`���4N����P�"Y�m�c��Eۂ�z��i���m��%Q��"M�z)
������!�4y�
��Q󈢍<��~���onӢ��$��W�A��^�� 2	�T �}�iXm�p)l+gBo��gL����cV$o���Q�]�;.�
9"�mL�P�obh3�Ih4��s�dӘ>�1)fh+�I�J��#�� ���#��b��ͮxH�je�F�`��z�
��O8�
��~��;/:��d�m�h>�d�{}�л<��t6]�qY���aT��}�[l����XG�i��i��[o��/4���I."J@r<oҷ�m�H�ࠔ]��oN��A�bZ��4��&���+'���h�6m�aIz-J�F�T���"�)�H�e����{P�h d��nÕIw�Ej�A��ؓ7z�چ#]��BB/(3�����6�'�&cyǶ���[�h������Ea�i���.<����c1�,��k�l	�2�$�g�[�r�rL�$��Ta-�Gثɦ0���`mhC8��1-�=
�c��î���[�O�<�"J�E����iXLŴ,�^�-�ګd�ӭ��l�P��Jm�p�4�]�X5vTƈ��M�+�������]��wݍ�F v�<��]�BqWU\t7���
��bw���Xe�
��bw�����@�n 65�bw�?�@,&�|!s��ۋ�a���[z0E�hd@>�M��ͭ�;�-'.p��
�4��I_E�3j�; �լY?f���W/�z�2�Yߵ�C��-j1SK~<5�|�����l�]�s�b�|�i��AM�����W���E�6V��W��C�ŐBvx�6).A��$��k�b����=�tGX�m��VȗZ����j�ǣ���Zq�F�숓�M��������=�+.��&�����ҐՇ@���H���Tn�OX����Li�fmi�٘:ݬ���>Z��)�2������?g�\��\�.Fu"	�����܉��Ӎ�����ͥ���f�V�fJ�Lӆb�8��z��s��/kr(3������os;o��]��u~��y[��m�D*��l8�>E��7f�0
B_%�7G���$\��n0�����i�̖2��C�-8z�����ص0����{� �:��9���";:1Vc�IvA�L|�
IŚ$��^��o�3����Ӽ0�\�x|C~�A$�o�E\ē�Z���R�C�k/��wP��z��x�IWt��!��t�>�~,��jcaaq�lse~M��J䩽�aH�ϙ�[�����.R]�R]:� �6��]������"��;�b�;�XNC,�&��"L;(%���X����pĂ&ͯ�H�شY%X�W�RqB�n��Њ�
9�T�ԊblH�k�?�^#�<�&��G`���jY.0c��7k��|����զG��ý�`e.K<D;�g��8a-�)�6�c-�h��,�����U��NeH�Qh�jSJ�%)l'�� �SE��K���!ב��(�����&�R9bz�Nbz�X_ic��&Q
c�#5��*Kw�5��l%ΰ��{d��ަ� f:sduw�e�^��Ux�iz�J�y�+3��\\-�
�5�L�#~S��u1����1��sZXm��YI*��y� UF�Y�p;�(�8���=].F�����;�+0�#8�;g�1	ߪ�:7#C�u�Ո�G|�2l~�[���^Yi���L!�]ي���_��_qśb��kR%
��Z���I�v�Ш����2�+Ȟh�gB��*��O��NL; ��m����Bt.�
�z�&=/u f �]v_�ɱ��y�
��]y�&�2�M�lIb�~+B��:�6吁ӏ���񽨐b,����27�2٘�l�r�)
q���̱
��p��U�����fG�I���8�-��e���a����U��0�ΒO�I�N�͜�!��M�(ڤ�9��8�aޜ�Y��;��p���f�,,�=ȇX��E��B��B"�j4L�^��ҡV�|4=r3)�K��K��ǐ��H������M��l��6<��V���^�JC��$�5f�{3
��x��"����q�nW"��ʍ�h���5Ԯݷ�_4\�l�φ�G?3���Y\x04���1�IO拊�v���"����w�J�<T>�b&l���5 TU����ؤ�ޞL>l�r�;���K����Pru;Ur�I�{c&5�ەl ��3���@�`��(9�7'�F��M���֏��I�����0v0����^�_�r��� ��j��)j��q= ���m�&L�'���y�>�����]Ԯ4,R��¿Ǯ���=G=Ǹ-v�������;�8Tz3�&�`����ё��n�� ؁T�t��A�����c�Y���h>O#�������������9xu�b���%dDͅ��p0J��Q�.��g��5-W����?T���?0q�6��a������� &�~����̉÷��y��ko�������ÿW���^����?�������?���^��׿����ƿ}�����_��o��^�����?x�����|�[�����}�ů|�O�}�O��˯=�_�򫗿��>�ʳ{��w镧/�����������o>��o|�C_������=��g?��g}��G�{���{��<��O�_��CO}��~����#���c�{��������'޺��;��@��˗����o�ad䖑
��>������t�ݏ��	��o;����}��O�~���	r��g�U>�[���?��Ͻ���`���{��?{f�;���nO^���w���7�����~��S�G�4���Ї��?��?��`��|��]�����٧��������G������w��ңo߿z�S3#�FK��ޓ�GQd.��E<v];ٙ�d2�4~�IB�$f�(��L'�0����Y�Y9t9TD%@#"` ʍ���+���������\=���ԧ������W�zU���t����-��S�n|�����-����V�T�pdz�Q�����`���a�r�n��S�0	��o�i+�F�Rc��`6��j���,��򬎔�!�?}��P�O���H��?���d��
���#��Gi\���4,W��r�Уx��3?�
._5�չ�}�>����������/K~`�w�K���\[~����KB��W���n�}��-_ݴ��w�z_�]
�������?^��ur蕃���[I���g��m�����B������ �������gf���H���� k�/���СC---���;v�X�h��v��������%z�疒f�������w���=o5
�lݒ'{��}�5��Z���G]�����^��]sp�����ژ䤇��we�V��ϫ�۸`U�&O��/ߒ��'o���o���~������oH�w��#�$�5~^�������=���%�_�k�)-i�ߖ�~|~�E�K��[Au_�_�V-kX����nhX�)qˆu��>����5�\�ȱ��>y���Z%#��ų�3@�r���%�����?��ŋWVBFll,�$vu�?߾���{������f&Z���z��D����e#�-�a;�>���MkV��G��_e�w�ۍ+?T��k
o�}�tן�8���	=��.97薆��~���tk�[�^?~���+n��?�t�n�g����3�}�t.���W+�ퟰ����;J�cɿ9���b]��	I��$����Z�~v��7�O|����_�}�`˅�?o��ٛ�~8}���ǿݶ��Ɲ�x����|y���=��G{v�? ���|����5z���y��S'@��N�v�g����֗ξ������_��m�v��x�����������>��t���/w�:���[���O�_����o�x��Ç�:�ra��O�����N�����oO�����o�/o^�捦�/��Nm�|��54���g7o>�i�ɺ���?�f}����?hhx���ڹ�;v|�}��۶�kj�����+��۶�={>il�����Ç��С���ג��W�ܷ��C+V�}z��u돭~��&�Ć��m8�n�����x���o�l<���s/m}w��]�V^���5��mzs���/��6������6��S��4���3�z��Y��]�0���͹7�[p�c�>�_�<�o��]���p���\:�W��m�ew���ݺ��9��[򭶑ڤ���_fqUO,I��+��a�{Bq���;R3����@��p�dݸ�����}p��e���1U^ع��Y�fe-������=�T��=g�e�%͍̌Y=/K{�UF������r��uKLh�~gs���^rcϝκ��(��ΤSO����!W>9�{Ҍ�kp�M�O�u�����lB�^�&��KV�Z��ӵ�}����9�D��;{tp��K�JY�Q����ݻ��허����jV���.��9)���
}��TP��n�T^���n�M�����om���`�4����t����^��W��4z� �u���~�O
W�\��>�3?������~��8{���o]���pjP��i��\��6]�{<�φ��<:�ǙcC�L�m�=6����7��4��3�^�5��ﲾ�{�t����м;��rŢ����,J}�<g僕���>��%�˺m�߲߬��;�S����Q�DEm�6����e����? �C�a�9}hZ��wJJ�k�/Or\Tc�ˢȉQM�e�>�M�S�ɡ��>U�V{9_���dd9�>[��n��4[�I��5����F�MŖ) ���8ܴ�O�\JvХg5�3���v1P��������<��N^0L\�J6vP�(���� !QV�e�����ðG%)*;l�t	�2ݒe^��WctÂ>��#�:@5l���X�!XI;��j����O�`�a���#�/���R�0D怰�H�F����*y/��!����d�Y�͖�8?(ފ�H����yD�
_L�KQN��x/c�G��T��	�ɩ�j�#�VVq����/��
����x�Z�B�]�	i�nF�I�l�%�1�zZu3�����:��Li�L���2�M������y+7d`צV4��9�)�f�t@�FC��J6�kL�w��wF�Y%��	�dK�Fz.A��x�@�B�������)BD1��;,�p0�H� º��\h�3#=�wK
O!Y%i��J�����&6���V]�<è�J������>�Ox �X��`|t(TWMa^��3�����@�]c���;��6r��
�ˤ�#�L����W�ZT�W!Z�����:���g�	ƪ�>�g^�u3P��r�|
���Dn��/CG蕟����"�TYUP�I��Qme�zgRR2zNN�SA�� u.�"b��fJ��A^r�DEDa$<?�h����SR2����* C�^7�&����F?�ݧ�B���l;� �m3�
�q����S�:�� Hk��bLX�r�0�Q@� TF|�	���КMJ�?F+�(9'4�x��W�֚3�FRI^��ǹݐ�=2N�*����T|A�V��i�.�"�I���?H�c�H*ء�"�c �D]�<����	��
'0�h��4��n-+/.*�؊���ȥ���32���<���z)T��G��a��d���R�
�Nb�8�'feQ�帋���d0 ߛMj>AP5���:�6�V�1�D3L+>-�Ee��@���h@��ڊk\D!
���8�+S�F�F��
����B8�Zek�0M�V1-��õ
���T]��X�_a�m@�Z8w���צ�R�0��zC+||r�W�GL`m
����c��e��S ��Q��* ����֘R�W�0̮X�P����U��8g#v�����<<ȅ%>����'� xa�	L\BV��x��W��.�G�9	��7q�X��|k*�DR]�(X�Q���(1�;Q�F��唍�ߙd��pvi���y�[�A�X� �j�3(�|�=�pbc0���p����J�Ccaq�u\qQY���n)-��rsJ�slcs�hoE�c_�uDoqL~i��Һ��}"m_Ar{�hU�1��P���D�D6���o���h@@oHC|㹾��
'�#�籧F���C���Ա�	� 0Ƶ|����1�Cz�L,��8: ����D^I�Eu15�1*�A�ɷ ��g	1���t��sJ4<�����K��Z�<����~F�7��P�f*ư�B�&�I	NVӈ6��4`��$ �6$�BR��d�[� +�*��3Ȧ�"km��\�r5՝��l��{0�I����e?S�-�v�:�?;��+�hWy��Fc����.��8��o��rGH���%��?�0�����)��|H �
�$O�/�!����Y�p�c<E���jxF��CUY2���]P�,��ע�9�e�j��ī����
,���;~�[�Z��{��q�]E���vc�c|6uG���e�
]�r����U��Z��(�Ȃ6Ux=�MW���EV�5����6b�jNO�ӆ���?]�:%����@��p�u�kt
�d�N��e%�s%I�Jh��	4�(�C�	����x2�h�)=�E.� *e��t-0��y<`0���◂�(�ð ([���R�����k)�/R�8��!��
�1��C��I����~ʏ.����H ��t�f ������Q�*?-96B�S�o����g�^�3�@M�*�_%�`��C�ͯ��O���T2��Т�:�YT베iX
���j���d@q��!�Q�U����U�ҴP
��4�*�qՑ� ��$<�<;\@�ag����-��!I�aI���4�rڲ&��0Jѥ�p��(�ע�a3&�BD@�G-��B��$/�WÏp�hЫԢrxi:���d-�%�؇
����;_�?<������H+���u"Ž�4O̰hF�^5�[��FM�zqpW� ~���}��8yiKϒ6LQ�C���J���U|E�W��!��we��2�� ��[���;�������o����tFP�|�nwDH��Љ�"�/��K�v��@�i\���S��))�+8��D"d.x��`HӸ	+u$[ʉI��� N�HI��w�h�-�chi���+�.bj��q��]��6n5d����}#��a��$��@�����*vHW!�j�
����]b+G��"H��qp�"B/�n��3ۮ�&����l#��O��2�_Zfz��O��T=�WL�Q�y�2���j��	��w�8\�M�he�� ��6
�b�Cۈ�`qP����*��zN��5A.����D�^w�����Ω$K5E3��8�J�.<@n��e��Rd�b.Ήr���mg�����,Jk�Y�Y�8V`���a��sKZ�R�Y�P��@dԣ!�ݕ���6P���T�b��mQ��jxR�������O�c�j��Wy�1���b~�_�؊0��G�l�=є�m7L%B��)�U=�lG����
��)V;�kG|��
tC�����I�#��d�З��0�T~�".��O�����3gdd����'����SR;��Ŋ�w�&�{ph�.�����h�v�L�M'���N<�'nJ�6�Kqs��xT_7"���	��@@�	2�I��Za�M�,Z���&�!%č�� 0���FE�J6�e
%���sD�"��K�D..]ڎ]��������QO�p���-#,��SIP��j���I��Q�z�o2E���桢�7e����+�w�����HBL�J�#��M?�ᜌ�*C^�����F�C�ＣQ��WAAx���(d����"PJK�`a
��+�H�(�@
��n΁��J-)�4B��2��,�&�z����hQ;�l�
���N&�y*{�Z�Ј���*�J0��z�ta}�THPLB8$�ډ�%�
﵃/Q;�{
��]##*�Q��Z1�6�$�r��m�ˈ
}���'�:�IP�q��a>��D�e� f��XF�"�9L�@N�"fG�G�s��s`0������k:6
Ȁ]>��Q]B ��hH�����ċ�/t�E�WƴGK {W*|q��d)�!$َAt����4��{�����O�E� ���^2(*�"�?����M�.T�X�!	�cI�3z�2��;��B�a�Ƞ�f|MiJ�X(.���0�Q\vkhzKY'x���~�/��<Ӷ���МDc�*�y
r��#R˒�-�I�Gh
�qf�u�! �В8�aYQ^$Iv� B�2ʐh��2�?��7�B���#�-H�%'z�x�)��F���~�J�`�����J�j/�Z��������k�0�O1��!(tr����c�0��p0E����B���'�:�t�:r����\�	�j�F���4�Y���C���]�����u��Yn�B��;t����;�<6h�x��Ds#����X��J�^�x5BC�����U?�+hd.Pd�x�:_	�Dr=�(*��\@|��<��q�-5S�����*l�peB,�l��:��Z��1�TD�n��vSc$�^ ��1�����9	�K���:���?-�$��̡�O]��3�@��H��t n(j,`$U9K�-g���R��yO
��k�%d���T0�N�T�
�R��!FS
<�0�91�R�*K�"��d���E屴��rh4���a�(���(73�X[~�4��_��7�[(+/� �H���(��h��YTu��A{<���A��� '�FZ�Vӻ�M�8��ZY>)�RY��?�;��}=Mo��C��!d��?��ey�ȕ�)�W�J+��4��"<FқF�d��<8��t���$K��2�'�K�x�w���|)N(�����Xt���t� -dV�TYb�P)��g� ��s]�Y��	����@�TF��5'�Z��[J��:e�ې���F���}���	�g�,Y
?Q2f��@�t2�EU�q���,Mo_5 ���%������7����G-M��i�D=uX1�̦4���9s(�33����n���w{���D��g\�9'������
���ʃ����r�1�±}=6Y�l��U���Fc���F���#�%�Z�V��}���e	�t!��K�g��tO��-l��yS�3g��*.tߎFt�on��߃�U)����?l�6P���etڝ��`6Tƫv�����+��o;��c�W*���}������z��ݻwM{@O2�4j��'h
m�Y�}��ySzw�A������f�ݍ����0����I�~�N����צ����Y�K��~��i��Gğ��L��~K�YG׭��O��?ݘ�c�$ꁡ.�κ�����F������jڝ���W���{Jvg��'K��������g;{;���b���gw����(�_�
�H�E��~�F,�4]���ߵ�[o�]��3T�*+�����9��.��gv	?=��@�1��/�/��]B�f�ß���6�#�ծ!o4�l"ۭ��߼�W
O���pl�+�,�6��f|�Zǝ��l�9�����;��q����E��ۊ��6/�E���f��%~�v*~�-T��&���D�Ǹ���&i���i��}r̛:<9y��$z���Y�ڴ&�?O�����Ka(Խv�6��u�fc��{�(Is�ǁ�s�-[/�g$����c�		+�Ȳ�~����A��\t�+3P*���>Z�C2�)��F-U����p�f'N���i��n7���q(H
�H���§6 ����z�����1YH�+G6�(� ��B5CJ�3�N��)��vU���=NG-���׆��:��$�n�q(���!q���C����a�������ڕ���zn�i�b�/"֝��m�F�j8"�c�� ,�M��ƻs�Uۢ��LYx�竍x7���\��H����mԔf��'��F�L�ו�}�2; �ӓ��T�7^�"#
��	��$���������7�����2��!5�w�w�7���R\Ȏ�)R �Jz��,�`�s��\�y.���H�����E]���u����r�t��A��͒&�I�$�D����$�3��E���)��9ĭ�����������P�_�35�0��8��P�+?��0׮�����b���#�~&���{Y���,�7;��t˸X����>3x8;���QhJ�_i�e�ۦ�A��S���SO���_�}r��϶�cp��oO|F`��
Ho��r��q'�씗���GEJ��{�"������2��r���
���h����|U9r�*��:nZ�mm.kl��?�z�F��'��o-�( k�:jc�묷��zܛ�+���l#�Ն���jڎ�M<K�輖��];����[��8C:sՉ+��jO�7NIC�'p?Ȟ��Ⱥ�Q�H�:eT��>�����b<'
�c��dó*���ѭ��*@�oj�zR=��[^���|�U��6��m��9c��Q߂��^�5G�"���ѭX�xL���p��8�mǲ��� ��ˎ�Š�a��H Ov+�}m�
�Q�Ղ�� Y�H�!I�R�K-n{x����
U_���V_����H5-f}h�t��КV���j*x}��9��/���/�_3���2���|R��꒜ܔ��'�l���f�	f�����܉�}����]$�����&6���kK�"��(��������
E�h����BQ^fG��n��^#��|;/�}���/'+�}A0�P�޵� �vک���5�������T(Q#�����ˬ�С��f<j3)W���$H�J�N�```dL��V}
���� \˟L"�.��n���v����ǃÓ�V0HO��@��K����-�{���h�~I:��h>��עpE���b��
��}EL�1�MhJ�+�?y�b�B�+���G�]��E���|˴a��UH,f4n��}��Di��+|{���wq>w�vh���r%�i/�_�%@��x8�%����VԪ��7����e*j���0b���Xў�ق�����Y�Z��� ��i9>9�ԫ��OF˯m-~��^�j��+Re�Rk@א�,�	D�f
��4���M�C/(G��L.*��`���x�}�tZ������� dĚ�m���p���l�ޞ���>�������D�a��1��΋��
+����i��1u}��>9m����m�L����3��k���8�\�I{~�.X�?;yʈ���� ݬz!�n!;���9���!���={+��&�p�̊L�A$�9�U`��j�x�-�����U`�Р���Ϡ����XD��J
gI�4{��i3S,��f��_H�� �L7�ʐp <7"�7y<�p����bUӭTT�ˑ��:�PX�Q������|)�jϢ��/� T�x�q�:$:���}�v«�����f�	dYu��0w�����X�m���ZN\�U�:Ϛnt�RX��h$hc1�Xd1�����!qo�820p��z���I �l&p�Ï� 4��dA�@���%~y6��o�Ծ����"��U�RHO�G�k_(� ���Y,�У�(�(�Ѡʸ]o�诮^5|��
u��ZծI���������k��G�����+��'\8s1���h�e��>bg�1MD,C��n.ŭ�8����K��):���t�(s���;�z��u�i�q�h�	l���'��w��
�_��a���d��Qă�Ǚi�5Wΐ(}�f�ᇡ`98>p��Ѧ9We�
���"yy���lf����odc����\+�;��z)�oj�m�����m�j�_����w�n%}K��=p��V��H{R3"K\t��$�*�]p��n���p�;�_2R!|�FӤ$l��n��
�x���Fy��)a���8S���×$��@l��V	7��r�f(���1-�qN�"368I=��[� |�%�y�3��b�l�
v�Z$lF�*֚��Xgd� �?��3ݴY���'8�Bv2��&<06��qScVsXt�܏~�gt��@���5p|AU���aF9���?��3
�Tٰ�yo�t��A|��3T�qP�����m���Z�u�?���%�N���b|Y�ܢ��5����i��2M��G�I�l�1eӫ8���1� Dȯ4{�G���?e!R�'o5�-���e�s �kH�������9�D�5#	ô}��ɵ����E<��-��kU�t*�cx`C"��"y>�lʬƨ� ���0�zH�:�IX+��癨�
�.R�8�2� ���Nj*�M|/����x��~࿮�ғ�-�����(T�}�6g<X�37u �\�I���e�  �.��pu+�a���gޓ��d��`�H�RPԽD�N2K�i0�
'��x*�ٓ0*Y,���1ӈ�U���L��b�����^������6�dЍ��i�^S�	��Ɵ2�c��������n���0𮱵�Á��6?V�;����"�L���k~��'���Ɯ ��}�C�w�Je��gd&�h��p*f�i����(��h�f~������W��"7a޶z��{� �>�O���8�S4��J}��U*
�&�
2�I2�2���z���[�l'�GU��`����o��hv�N�!.�( e?�4�Iw8���Xp��t��n��"vW�j&��z�5d�(#�5z�dz �+�ʊ�
�|��]X7�u���F��w6/�)���I%�Nh��(yu*��4������>|�0�{���P�&c�a�@���=��l/b+3���A.����5�ٳ]�{x8G0�Pl�M+2�����aPA�ߚ��:_kBE���5x\K`^Z�]��4>b����Y���M���l\��uJFy�
Ʌ���+���\@���&W�+�lӆ�\�	�s�i��t�;���U�R��=�C2\'f�ڈ1vV�B�/�؆c�`��5>d�7 �Qo7�ӶH��y9�	��?�25���|@ʞ�|O�j@��Tp�ܔ
1�|�����_xtY9>�~���,k��ݱ��Y��qD�VS���T��������|u?/�u�G_iC-<���7�` ��-�����cH9�i������ak���r�8�ǟ�ܽ*)ް�8�5�����wF�1>%���)��� ��a���8}���
����3z��$����rԘ��[Zf�ֶu�§M�Pr�K�`�К��͐�k��b}Z[-���������
�&�6�iat���<'(�}�� �g�(��q<�#��q��6�4�N�IpMa��"�\e�!��b1p~Ѭ�n����y,� e�cv
%+e!Q�Kw.`���p�ͼ�
>�ĀzM)��\՛�U���4��;�e�>�j���X��M*�U?��.询�����y��EZ�!�Y�AQ��ʕN�8QYs_�*��g�|<�������w�Q�H����|ִ>Pܒ���&�C���!s�)�P��0�)�~
M�c��'+��VeU�uf�S��S��b择�̄pY����-������!��d�7BΖ)������ڨ���M}!s4�������%-Ms�*5L��`���Boɂ��!� R�(D�1�$۞����C2)|�5���o�ٯ�g�.a=���쮹Z(�@�ץ��ZQq�����2yZ�Y��13�~O��s�(������1�v���U�!�]6�H�
;d���Y$��Z����xV�%jS��M�0�:���M����Z��uR�� ���GzHg��&5��wL�,�,�'�S�i�	2�(Z��W2�Sj����	9�Vl�ܨ	�7wUH�̟h�7��-BZ�\BZ��5�����k���fY�`�v��)�U�P[��6��W���z�����@@�v�h��ѣ�f:L��#��V��P�6�e.��(9�>�ܩ��/{~��:a���u0b�}	^�\]D���Zh9Z��{�뜒�������0��e�3_�TJ�!����1]�m�z�fOtR���M��K��(��-��ĩ�Ԙ���L���^�U'�O�W����II�^��?=����.:����F� �픶:8��N\j^���oS�KI�� ͭ�祬󷳣8ǔ�
cs�OM��xz�N|x���Ss
���yƸ�3�W��c&��/Cٝ���,�r�,�+t��.A,�^v�KΥ�Q#:��[�b7,�·�/
����SO�M��.�N�X|��>��W#����Z�8y �.�����Đux�Ѯ������MǚJ�\��o��^�O�ёFK6z��䆒�u�h���'�3~+#�*"�躀%�x
�;���
@X1J�Y!�OA������t!��p3�F<8%6��hPH?�'��D$��ϸ�aQ6
 ZcTf`P����~e�i�P�^e�C�xbQ�z�
��&��'�[DQ�-8����T��H�zQ_���@5	���7d����&B(·L5���ID��~Sx VX��^�<w^���)�\k�m���mm�ѿ����-����w���6���+�٠
H4�_J�D��!a�Sc�~iV���+��f����k��
�޴.@x�h�����Cj�� /�է��7�6
��T�bŖt"�f�N����+m<%��a@%~�b���^qvfQ����Y�&M�^q�(��71��H �N�G�"EΣ��J���]U�*��pn���@7�x=` ĝf��8�������!պ�,=]�n
!��A�*J�:L^�o�9l�B<�5W�����5Ī���+��S�k�;�PyR&-����	/.��?߯Ն�o4�~/�*
��goo�n������ߎ/$7K�p�%G��_TMz�����
�^�M�dDH��̙,c�<�2~1�a��n�_�^��=��B�Cy�s���7��_�[�/�"��_�拷���1T垷}u����'GG�����!��p`�Sך(�IQ� e�NJn�1�,������&�X���$�Yɟx4��u�+�8�rA�����ʽ)�cm2�sR�7W	1 �/e����A��1/=OpB�������uJԎE�.w�O��E��H@�i7��1S��+Vҡ�~�+b��5F���`T}"�	6)�Е�ΥDN�|i�U4u���kF����3��e<Օ()��>I�? ؎B/�K�AS9 ���4�a�t ���y��MqL�k�jxq*ĎG�@�HYA��� �Y������gDrNfQ"��o,��<"c��4���[S��0nY	���hꞹ�i�M����2����
f��,
q_4�rB������71�"�	u؄0��"5Ʀ��/��������#s��������3ԲYg����:���٩��R���I���q��xڇ��\��kD��D�c,�m� �/�v�4��fo����{&ޒ�)|�K�Gi�N/;Jx�4�)_'D�?L��x
��@�y@Is>ZcK��ʢ��ܕ��X���Ae����=D�XjY��:�c��������9�ULI�3�m/�җ�����Lck)v)��X'����ؾ�/nV��8���-�2M
�� n,̑	�(vəf<<F2M-<�� xA�<9!?��,���\I!~z��&�Wn�68�r��>^�T�T������xt)�i!��b3�9��O��]8��^�r$��0��+�1���=��͇[6ѩ&=��M���J׊5y�t�.�3�w{�I���O�A�B�,8=����4��i���zQ�7��]g�=�,���01O9���؏��3G=�+���0���.�1Tg�6�6t�Ii��달^h3xw��gNz���g�f*>WO9����g�k��ncgw��;w���HULD�a_�����%"ѯ��<�������!���G(�<���.X��]r�@�+*���^,��eJ��G�Ÿ;�$֝̈́¨FڤMg�`Awg?@�{A�:�'"���=��ўQ�<�M�)K\��}�G��%���iJ3��K�(Ɔ��9:���Eҙ��Ӹ;�G��aԄ�/�HH��E}�32�����֦��3�A������`T:���@�6���ը�MFw2���<N7��6��8w��"�юh>v���κ5_�n��ۧ������QRamr�sz
��
�x�f�������	{��bJ��~��W�)���O
��OFW�\�f'ӈB����2"�$�Ń��~h��x'���& ف&��K���y��!�7���cA;�F�����ew�9�c��zcX>ϴ�Y/�F��~I#J��z
'�K��8�xyr�{�lO[�/�Zߘ�7�����]�@��������r�WzIY��So�An����6�s��L7��m�Ph>O��1�w닖�l~o��f?��N��%�S'�{���x4�|*A�7�t+�ې�x���W@{�	��֩�Hi�Q�N�C�Xt{�����|��W�Qo���t�Hz]��i}�ѯ�� �SBQ��Өwы/��k:�K�ty	#���%;��{
�
�2.}�N:��m	�����k�v�<�ҥ������b�(T����^\&Yh���Lh��/�)-�AQΣw����1=)����I�_�0Ȉu� .����G�-	������P����]�Kw�.ݥ�t���]�K������� � 