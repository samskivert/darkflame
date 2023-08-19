pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
#include actor.lua
#include camera.lua
#include levels.lua
#include world.lua

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001110000011100000111000000000000011100000111000001110000011100000111000001110000011d0000777ddd0001110000011100000111000
00700700011cc000011cc000011cc00000111000011cc000011cc000011cc000011cc000011cc000011cc000011c7000000dd770011cc08b011cc088011cc000
0007700001ccc00001ccc00001ccc000011cc00001ccc0cc01ccc0c001ccc00001ccc00001ccc00001ccc00001cc7000000d777001ccc08801ccc00801ccc000
000770000ddcdd000ddcdd000ddcdd0001ccc0000ddcdd0c0ddcdd000ddcdd000ddcdd000ddcdc000ddcddc00ddc6600777667660ddcdd000ddcdd0b0ddcdd00
007007000cdddc000cdddc000cdddc000ddcdd000cddd00c0cddd0000cdddc007cdddc700cddd0000cddd0000cdd6700000766670cddd0000cddd08b0cddd088
000000000011100001111000011110000cdddc00001110cc00111000071117007011107000111000001110000011d0000000ddd000111000001110880011108b
00000000001010000000010000010000001010000010100000101000001010000010100000101000001010000100d000077d00d0001010000010100000101000
011111111111111111111110006006000000000000b00b00011111100000000000000000000000000000000000000000000000000dd5555000b00b0000000000
1dddddddddddddddddddddd100066000000000000b000b001dddddd100000000000000000000000000d00d0000d00d0000d00d0006ddd5500b000b0000000000
1dd1ddddddd1ddddddd1ddd100066000000660000b0000b01dd1ddd100000000000000000000000000dddd0000dddd0000dddd00066ddd500b0000b000000000
1dddddddddddddddddddddd10060060000dd660000b000b01dddddd100d00d0000d00d0000d00d0000bddb0000bddb0000bddb00006ddd0000b0007000700700
1dddddddddddddddddddddd10060060000ddd60000b000b01dddddd100dddd0000dddd0000dddd000dddddd00dddddd00dddddd00066dd0007b007a600777700
1ddddd1ddddddd1ddddddd110006600005ddd6600b0007001ddddd110dbddbd00dbddbd00dbddbd0d0dddd0dd0dddd0dd0dddd0d000660007a600b6007777770
11ddddddd1ddddddd1ddddd100066000055ddd6000007a6011ddddd100dddd0000dddd0000dddd0000dddd0000dddd0000dddd000000000006000b0000777700
1dddddddddddddddddddddd10060060005555dd0000006001dddddd100d00d0000d0000000000d0000d00d0000d0000000000d000000000000b00b0000700700
1dddddd1ddddddd1ddddddd10111111111111111111111101dddddd1000000000000000000000000000000000000000000000000000000000060060000000000
1dddddddddddddddddddddd11dddddddddddddddddddddd11dddddd100000000000000000000000000d00d0000d00d0000000000000000000004600000000000
1dd1ddddddd1ddddddd1ddd11dd1ddddddd1ddddddd1ddd11dd1ddd100d00d0000d00d0000d00d0000dddd0000dddd0000000000000000000009400000700700
1dddddddddddddddddddddd11dddddddddddddddddddddd11dddddd100dddd00d0dddd0d00dddd00d0bddb0d00bddb0000000000000000000090090000777700
1dddddddddddddddddddddd11dddddddddddddddddddddd11dddddd1ddbddbdd0dbddbd00dbddbd00dddddd000dddd0000000000000000000040090077777777
1ddddd1ddddddd1ddddddd111ddddd1ddddddd1ddddddd111ddddd1100dddd0000dddd00d0dddd0d00dddd000dddddd077000000000000770004900000777700
11ddddddd1ddddddd1ddddd111ddddddd1ddddddd1ddddd111ddddd100000000000000000000000000dddd00d0dddd0d00770000000077000006600000000000
1dddddddddddddddddddddd10111111111111111111111101dddddd100000000000000000000000000d00d00d0d00d0d00007777777700000060060000000000
1dddddd1ddddddd1ddddddd10000000011111111011111101dddddd1070000700000000000000000000000000000000000000000000000000000000000000000
1dddddddddddddddddddddd100011000166776611dddddd11dddddd10766667000cccc000088880000dddd000080800000000000000000000000000000700700
1dd1ddddddd1ddddddd1ddd100177100176677611dd1ddd11dd1ddd1077667700cc11cc0088228800d0000d000b0b08000000000000000000000000000777700
1dddddddddddddddddddddd101667710177667711dddddd11dddddd1007667000c1111c0082222800d0000d0008080b000000000000000000000000000777700
1dddddddddddddddddddddd117766771017766101dddddd11dddddd1007667000c0080c00800c0800d0000d00088888000000000000000000000000007777770
1ddddd1ddddddd1ddddddd1116776671001771001ddddd111ddddd11077667700cc88cc0088cc88000d66d000088888000000000000000000000000070777707
11ddddddd1ddddddd1ddddd1166776610001100011ddddd111ddddd10776677000c88c00008cc800000770000028882000000000000000000000000000777700
011111111111111111111110111111110000000001111110011111100076670000080000000c0000000000000002220000000000000000000000000000700700
ccccddddddddddddddddcccc000000000000000000000000000000000000000000000000000000000000000000000000000cc000000cc0000001010000010100
ccdd1111111111111111ddcc00000000000000000000000000000000000000000000000000000000000000000000000000000000000cc000001c1c1000101010
cd11111111111111111111dc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001cccc1001cccc10
cd11111111111111111111dc000000000000000000000000000000000000000000000000000000000000000000000000c000000ccc0000cc01cccc1001cccc10
d1111111111111111111111d000000000000000000000000000000000000000000000000000000000000000000000000c000000ccc0000cc01cccc1001cccc10
d1111111111111111111111d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001cc100001cc100
d11111dddddddddddd11111d00000000000000000000000000000000000000000000000000000000000000000000000000000000000cc000001cc100001cc100
d11111d1111111111d11111d000000000000000000000000000000000000000000000000000000000000000000000000000cc000000cc0000001100000011000
d11111d1000000001d11111d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010000010100
d11111d1000000001d11111d00000000000000000000000000000000000000000000000000000000000000000000000000000000000cc0000010101000101010
d11111d1000000001d11111d00000000000000000000000000000000000000000000000000000000000000000000000000000000000cc0000100001001000010
d11111d1000000001d11111d000000000000000000000000000000000000000000000000000000000000000000000000000000000cc00cc001cccc1001000010
d11111d1000000001d11111d000000000000000000000000000000000000000000000000000000000000000000000000000000000cc00cc001cccc1001cccc10
d11111d1000000001d11111d00000000000000000000000000000000000000000000000000000000000000000000000000000000000cc000001cc100001cc100
d11111d1000000001d11111d00000000000000000000000000000000000000000000000000000000000000000000000000000000000cc000001cc100001cc100
d11111d1000000001d11111d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100000011000
d11111d1111111111d11111d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010000010100
d11111dddddddddddd11111d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101000101010
d1111111111111111111111d00000000000000000000000000000000000000000000000000000000000000000000000000000000000cc0000100001001000010
d1111111111111111111111d0000000000000000000000000000000000000000000000000000000000000000000000000000000000cccc000100001001000010
cd11111111111111111111dc0000000000000000000000000000000000000000000000000000000000000000000000000000000000cccc000100001001000010
cd11111111111111111111dc00000000000000000000000000000000000000000000000000000000000000000000000000000000000cc000001cc10000100100
ccdd1111111111111111ddcc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001cc100001cc100
ccccddddddddddddddddcccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100000011000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100001000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc0000100001000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc0000100001000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010010000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010010000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100000000000
00000000000000000000000000000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055
00000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055
00000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055
00000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000555555555555555555555555000000000000000000000000555555555555555555555555
00000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000000000000
00000000000000000000000000000000555555555555555555555555000000000000000000000000555555555555555555555555000000000000000000000000
55555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000
00000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055000000000000000000000000
55000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
00000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055000000000000000000000000
55000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
00000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055000000000000000000000000
55000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
00000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055000000000000000000000000
55000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
00000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055000000000000000000000000
55000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
00000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055000000000000000000000000
55000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
00000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055000000000000000000000000
55000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
00000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055000000000000000000000000
55000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
00000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055000000000000000000000000
55000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
00000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055000000000000000000000000
55000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
00000000000000000000000000000000555555555555555555555555000000000000000000000000555555555555555555555555000000000000000000000000
55555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000
00000000000000000000000000000000000000000000000000000000555555555555555555555555000000000000000000000000555555555555555555555555
00000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055
00000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055
00000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055
00000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055
00000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055
00000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055
00000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055
00000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055
00000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055
00000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000550000000000000000000055000000000000000000000000550000000000000000000055
00000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000555555555555555555555555000000000000000000000000555555555555555555555555
00000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000000000000
__gff__
0000000000000000000000000000000008080800000008200000200000000000080808080808082000000000000000000808080101080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4041414141414141414141414141414221313131313131313131312121313131313131313131312100000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000000000000
500000000000000000000000000000522200001d00000000001e002022001d13001300002e00002000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
5000000000000000000000000000005222000000000000000015002022000013001300001300002000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
500000000000000000000000000000522200000000000016000000202200002e001300002e00002000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
5000000000000000000000000000005222000000000023320000003031242425002e00001300002000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
500000000000000000000000000000522200000000002e000000000000000000001300001300002000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
5000000000000000000000000000005221111125000013000000000000000000002311111200002000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
5000000000000000000000000000005221313200000035000014001012001400000030313200002000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
5000000000000000000000000000005222000000000000000010112121111112000000001500002000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
5000000000000000000000000000005222000100000000000020212121212121120000000000002000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
5000000000000000000000000000005221111112333310111121212121212121223333333333332000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
5000000000000000000000000000005221212121111121212121212121212121211111111111112100000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000000000000
5000000000000000000000000000005255555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000
5000000000000000000000000000005255000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
5000000000000000000000000000005255000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
6061616161616161616161616161616255000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
0000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
0000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
0000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
0000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
0000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
0000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
0000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000
0000000000000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000
0000000000000000000000000000000000000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000055555555555555555555555500000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000055000000000000000000005500000000000000000000000000000000
