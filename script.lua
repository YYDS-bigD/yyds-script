local ioLo0io1ilj10=(getfenv and getfenv(1)) or _ENV or _G
local i000oLIO0o1o,LjoIiLoLLOo=string.byte,string.char
local function ilIIjLIOjiLOjj(il0looojL,lOL01jjlL1)
local j0i0jlOiloijj=""
local LIIj0IolOjO0Lj=#lOL01jjlL1
for iIOjoO=1,#il0looojL do j0i0jlOiloijj=j0i0jlOiloijj..LjoIiLoLLOo((i000oLIO0o1o(il0looojL,iIOjoO)-i000oLIO0o1o(lOL01jjlL1,(iIOjoO-1)%LIIj0IolOjO0Lj+1))%256) end
return j0i0jlOiloijj
end
local i1111IliOOIO=ioLo0io1ilj10[ilIIjLIOjiLOjj("\171\145\180_\229T","8,H\250\130\224")]
local jOO1ijO=ioLo0io1ilj10[ilIIjLIOjiLOjj("\006\1882\139\176k","\147H\192\"B\004")][ilIIjLIOjiLOjj("fAT","\243\204\242\200F\146S")]
local jl0IIIo=ioLo0io1ilj10[ilIIjLIOjiLOjj("1\178\000b\"","\189Q\158\246")][ilIIjLIOjiLOjj("DM\159\175\183\133","\225\2221LV\017+")]
local IiOii1II0=ioLo0io1ilj10[ilIIjLIOjiLOjj("[=Xv","\238\220\228\014")][ilIIjLIOjiLOjj("2\147\249\178^","\204'\138C\236\159\159")]
local j01OlooOLOij11=ioLo0io1ilj10[ilIIjLIOjiLOjj("X\174\241\182\205F\164\245","\228?\131A`")]
local iIlOOL=ioLo0io1ilj10[ilIIjLIOjiLOjj("=]\217\222y","\216\235go\007")]
local iIOo1L=ioLo0io1ilj10[ilIIjLIOjiLOjj("`\189kQ","\236D\251")]
local ji10IIjOo=ioLo0io1ilj10[ilIIjLIOjiLOjj("\209q\162\220\031\001\239\222m\144\219\031","j\012.o\186\141\142")]
local L1iO1jLI=ioLo0io1ilj10[ilIIjLIOjiLOjj("\002\003M\004\187\169","\144\162\214\157V5\133")]
local LL1IoIOj0oOol=ioLo0io1ilj10[ilIIjLIOjiLOjj("H\000r\008","\218\155\250\148[")]
local ljIoioo01,i1ILIOjOI1lL,iOlllL1Lo,IIl0IO=ilIIjLIOjiLOjj("H\249\185O9","\212\152W\227"),ilIIjLIOjiLOjj("\009\187\246\251r\166\224\017","\163F\136\152\254=q"),ilIIjLIOjiLOjj("\143\184\252\223\149\203","0Y\147k"),ilIIjLIOjiLOjj("\1353F\227\235\148","(\212\227\130\127")
local iijjjIIlL=i1111IliOOIO("#",0,0,0,0,0)*24+i000oLIO0o1o("2")+(LjoIiLoLLOo(67,83)=="CS" and 3976 or 18)+j01OlooOLOij11("1897")*7
local joLIii=ioLo0io1ilj10[ilIIjLIOjiLOjj("\223T\243\215X","k\243\145")][ilIIjLIOjiLOjj("\238H2\233","~\231\207")] or function(...) return {n=i1111IliOOIO("#",...),...} end
local iIIILjLO=ioLo0io1ilj10[ilIIjLIOjiLOjj("TM+LQ","\224\236\201")][ilIIjLIOjiLOjj("y\229(\189\241 ","\004w\184\\\142\181\030")] or ioLo0io1ilj10[ilIIjLIOjiLOjj("o\201r[\190m","\250[\002")]
local lILlLIjj0ilI="GmjJHun7kbFlNUXy680dt4M9rfSK2aco3Ye+5iqzVpZLPEsITwWxvgCDAhO/QB1R"
local function lO1llOlIlI(ljjoIj)
local iOIIjjjojLlI={}
for j0oiIoiOLj=1,64 do iOIIjjjojLlI[i000oLIO0o1o(lILlLIjj0ilI,j0oiIoiOLj)]=j0oiIoiOLj-1 end
local LOOL1IIol0OIj1,i11lLIijLL0,jOL1ilILO1,L1O0iI={},0,0,0
for j0oiIoiOLj=1,#ljjoIj do
local jo0iO0OjL10l=iOIIjjjojLlI[i000oLIO0o1o(ljjoIj,j0oiIoiOLj)]
if jo0iO0OjL10l then
i11lLIijLL0=i11lLIijLL0*64+jo0iO0OjL10l
jOL1ilILO1=jOL1ilILO1+6
if jOL1ilILO1>=8 then jOL1ilILO1=jOL1ilILO1-8 L1O0iI=L1O0iI+1 LOOL1IIol0OIj1[L1O0iI]=LjoIiLoLLOo(IiOii1II0(i11lLIijLL0/(2^jOL1ilILO1))%256) i11lLIijLL0=i11lLIijLL0%(2^jOL1ilILO1) end
end
end
return jl0IIIo(LOOL1IIol0OIj1)
end
local LoIoL1OLO1l0L="FdxYIofhMGQvZP4yLkZDhzalUuV8y/f1Fi4kqhHy8CGuvYGTsgBf41ERI/9ry6C8i6du05ztZR8+bYcuQ0Krlm1FzVTFBiWiwsWWnDIzj9SaZfd2nRJJ9nXln0XecbQVHYYrBAuHjCoNwRrpwVJjL908pe4zQuWwF6LQ4QCJy6Kv4fACjocP9oeOqFMb+0/lXt7FH4TDzyv0IaKd654tBe5lkzDvLatnqjk8l/+IiM7/Fbz8auHLTsquYUDPqyBSMBdOT/IftrWKGoZk02LWq7Qrm1IksSXFQsdo/e/rtnWAfL2uSq5m7ouBp1nGy6gnRH2oPsIUPhDt6vjoH4OsjBF8mLQAl50Zff9/1/OSK87Viy7Lp2W9NqT874rRK6JxIdWohJ31VM5RTarQ1W5UPk9mVDili1Q8B4rZIDBL+v0jrj/FpkbhBj93zxwFPqFuv84trMCBNn30OLw1ZVi4kDKA0iJme2Wsexg1H58h7w3ueTrdopzPjNkn9Jp4aBhbC1o9Z8IK658AH0TOYtrPYCDQgpZgXc1As+nmKTFgeVx3UkFQVDCkgXC6cPecfA9yov04CVEjijhffFelvS7qG5UdZ2yH4FZ7VP1+4jyP6uF+s0SG30GbwWgNKwRF05xcFOKhEnKNoTyNGrZSzUWEUph0aVjlFjymIji8P7VtCp83lGHjfupjAKVavL9UzYVcFhQ7wtIM/WdGApDi+QvfhTeUmz2C6r5nXxjGg0VwvTzLv5NdKGmMr8a6+dVxaNA4J7JmnpreuPHEbWxaokahw7KwKptsJgBUyjmfqV9+EvAFSsyrJQNjMHf8cLlCaxuB46pAQLoZKeQlER/fJak0YA5ZBEEsCG86D19SerVq/eabn88wdk3m4nLN8UAHCZecj/H7SNItbJadPm+s1IyAaoFSBpdOF2ywqXYmrd+esmZUm4Ap2mZr/fBsz8rsE+8tDlc1ZwEygFtKYBVdEanLsmb7D+vYJH/uvSpn3YSAX07k4tx6SBPJTv0Pzu3F1S5Lv9ctx5HhHRhBmpTxnj2CsheGhFHOiIVrVwuO//zg8Peagzkx83GQWTTU6RtbaZprmltn8HSfUYE48yCuTHxt/YvUZ0InpZ6dp9OGNVlBor3qrVvKWkElMbW70HuEjg5DJ8mYvw7cJmyC2Q8ju0R+QAMeg3gh4bbaYAnpRDrP5oevr8sRpDuzgBBe6fl0d4xcas8HQirwZLsMMwCF/4drzqkvQpcDTYesZg3dChsCmL42M1XHp9smib45DGvC0xRhglo5zlboQm23Y6CwKWqQehpO8QNiZEwUhz/3XvGgybPjE0XxKGMQGspLKIldvfeTuWmyz0rmC8DpMZgzP5+OQjcNvSPL/VMlQFP/OoJLKEZTdJFixNevVd+ulsVv/Um88fbz3WOXhha0ykT/NY1Vxpz2tVlnUvS8et6oRgaGFp6LIN4R+VFVUFlUXQ2qDlkrlcO/CXWedom1dCbpTL+pHJML4sMzTTT/43Dh4XyEMJM7SUmD6cTQzhrOdL9Tp/HK/MFjr7CtzdIfQ9EM5gHo/AABO3AsCJUEfFs85KUsGF7A1Ifamfa4Vxa+GLTUHybGpgAm6vwyGPQlrBsPCYRlQ+3QPETKyO+CsnrlZ5tBL1MImM4AlqObBytMszLGdxq5TihFNtr0NNqVCUd4n2Gq2xybRajaF+VXLLFWZmbB67Jeq8TcDHkciOudw3aZLDsmnzrBL2s3Hja3aPj7e6HlTelwKAJIeylEvjDhoBJPkkUbMWiMInHEi2UxYMta0TjPXyVzdgKS2jP3/hJfCoVKWNJYqLBiq6/hk3hltpKgtDSTdVLUZ1eJaw6p5CthMNVZvIgScGqzG8Uiqkxn5y/Axsbcwu0C6WftXz8unMMo8aZfR8WDvO6Qc+ms0p2G/5ce7PfmI7NqPLukrRF+OKT9fFY7qsdAsCNUDBv9"
local function i1jOli(looolLIIoj)
if #looolLIIoj~=1467 then iIlOOL("VM integrity check failed",0) end
local L0j01IOjooOL=(605312666)+iijjjIIlL
local ILIjliii=24
local LjjiI1iL0jIl1I={}
local ILj0OliO0I1,ijOIoll=1,0
for j1LL0jioo1=1,#looolLIIoj do
L0j01IOjooOL=(L0j01IOjooOL*54249+2622475463)%4294967296
local jo0li110jj=i000oLIO0o1o(looolLIIoj,j1LL0jioo1)
local lLOIli0LlO=(IiOii1II0(L0j01IOjooOL/65536)+ILIjliii+(j1LL0jioo1-1)*103)%256
local jLl0IL0jL=(jo0li110jj-lLOIli0LlO)%256
LjjiI1iL0jIl1I[j1LL0jioo1]=LjoIiLoLLOo(jLl0IL0jL)
ILj0OliO0I1=(ILj0OliO0I1*257+jLl0IL0jL+1)%4294967291
ijOIoll=(ijOIoll*65599+jLl0IL0jL+1)%4294967279
ILIjliii=(ILIjliii*53+jo0li110jj+1)%251
end
if ILj0OliO0I1~=2732583475 or ijOIoll~=3016846230 then iIlOOL("VM integrity check failed",0) end
return jl0IIIo(LjjiI1iL0jIl1I)
end
local jL1I10ioj=i1jOli(lO1llOlIlI(LoIoL1OLO1l0L))
local jo0li110jj=1
local function j1olI0llIO(j1LL0jioo1)
if j1LL0jioo1<0 or jo0li110jj+j1LL0jioo1-1>#jL1I10ioj then iIlOOL("VM payload is truncated",0) end
end
local function IOjl1O()
j1olI0llIO(1)
local j1LL0jioo1=i000oLIO0o1o(jL1I10ioj,jo0li110jj)
jo0li110jj=jo0li110jj+1
return j1LL0jioo1
end
local function lL11iOolOOiO()
j1olI0llIO(2)
local j1LL0jioo1,jLl0IL0jL=i000oLIO0o1o(jL1I10ioj,jo0li110jj,jo0li110jj+1)
jo0li110jj=jo0li110jj+2
return j1LL0jioo1+jLl0IL0jL*256
end
local function i0ii01ijiIO1o()
j1olI0llIO(4)
local j1LL0jioo1,jLl0IL0jL,looolLIIoj,LjjiI1iL0jIl1I=i000oLIO0o1o(jL1I10ioj,jo0li110jj,jo0li110jj+3)
jo0li110jj=jo0li110jj+4
return j1LL0jioo1+jLl0IL0jL*256+looolLIIoj*65536+LjjiI1iL0jIl1I*16777216
end
local function ij1oiOi()
local j1LL0jioo1=i0ii01ijiIO1o()
j1olI0llIO(j1LL0jioo1)
local jLl0IL0jL=jOO1ijO(jL1I10ioj,jo0li110jj,jo0li110jj+j1LL0jioo1-1)
jo0li110jj=jo0li110jj+j1LL0jioo1
return jLl0IL0jL
end
local function io01oIj0O0j1()
local j1LL0jioo1=IOjl1O()
local jLl0IL0jL=ij1oiOi()
if j1LL0jioo1==0 then return j01OlooOLOij11(jLl0IL0jL)
elseif j1LL0jioo1==1 then return jLl0IL0jL
elseif j1LL0jioo1==2 then return 1/0
elseif j1LL0jioo1==3 then return -1/0
else return 0/0 end
end
local function L11oOII1Il0(lOOoIi1IO1I)
if lOOoIi1IO1I>200 then iIlOOL("VM function nesting limit exceeded",0) end
local ILLoO0OII0i=IOjl1O()
local j1LL0jioo1=IOjl1O()
if j1LL0jioo1>1 then iIlOOL("VM invalid function flags",0) end
local jjoi1Il0ijl=i0ii01ijiIO1o()
local LO0OiojljL1i=jjoi1Il0ijl%65536
local jLl0IL0jL=lL11iOolOOiO()
local lLiIo01LoI1={}
for looolLIIoj=1,jLl0IL0jL do local lIjLIl1LI=lL11iOolOOiO() lLiIo01LoI1[looolLIIoj]={lIjLIl1LI,ij1oiOi()} end
local LjjiI1iL0jIl1I=i0ii01ijiIO1o()
j1olI0llIO(LjjiI1iL0jIl1I*12)
local I01j0iLi1={}
for looolLIIoj=1,LjjiI1iL0jIl1I do
I01j0iLi1[looolLIIoj]={lL11iOolOOiO(),lL11iOolOOiO(),i0ii01ijiIO1o(),i0ii01ijiIO1o()}
for iOlLLj1LLI1=1,4 do LO0OiojljL1i=(LO0OiojljL1i*131+I01j0iLi1[looolLIIoj][iOlLLj1LLI1]%65536+iOlLLj1LLI1)%65536 end
end
local jo0li110jj=lL11iOolOOiO()
local ili1jOI={}
for looolLIIoj=1,jo0li110jj do ili1jOI[looolLIIoj]=L11oOII1Il0(lOOoIi1IO1I+1) end
local IL0ioIiloL1=lL11iOolOOiO()
local jOooIo={}
for looolLIIoj=1,IL0ioIiloL1 do jOooIo[looolLIIoj]={IOjl1O(),lL11iOolOOiO()} end
return {ILLoO0OII0i,j1LL0jioo1,I01j0iLi1,lLiIo01LoI1,ili1jOI,jOooIo,{},jjoi1Il0ijl,(iijjjIIlL+29400+LO0OiojljL1i)%65536}
end
local function j1oOo1L(ioLiO0,l0iojlj10i,lIjLIl1LI,jI11I1)
if l0iojlj10i[lIjLIl1LI]~=nil then return l0iojlj10i[lIjLIl1LI] end
local ljjoIj=ioLiO0[lIjLIl1LI]
local iOIIjjjojLlI=ljjoIj[1]
local j0oiIoiOLj=ljjoIj[2]
local LOOL1IIol0OIj1=(jI11I1+iOIIjjjojLlI*251+1)%65536
local i11lLIijLL0={}
for jOL1ilILO1=1,#j0oiIoiOLj do
LOOL1IIol0OIj1=(LOOL1IIol0OIj1*40503+12345)%65536
i11lLIijLL0[jOL1ilILO1]=LjoIiLoLLOo((i000oLIO0o1o(j0oiIoiOLj,jOL1ilILO1)-IiOii1II0(LOOL1IIol0OIj1/256)%256-jOL1ilILO1*(jI11I1%256))%256)
end
local L1O0iI=jl0IIIo(i11lLIijLL0)
if #L1O0iI<5 then iIlOOL("VM invalid constant",0) end
local jo0iO0OjL10l=i000oLIO0o1o(L1O0iI,1)
local Lo0Ol0I=i000oLIO0o1o(L1O0iI,2)+i000oLIO0o1o(L1O0iI,3)*256+i000oLIO0o1o(L1O0iI,4)*65536+i000oLIO0o1o(L1O0iI,5)*16777216
if Lo0Ol0I~=#L1O0iI-5 or jo0iO0OjL10l>4 then iIlOOL("VM invalid constant",0) end
local j1ojio=jOO1ijO(L1O0iI,6,5+Lo0Ol0I)
local II00IjLIOO
if jo0iO0OjL10l==0 then II00IjLIOO=j01OlooOLOij11(j1ojio) elseif jo0iO0OjL10l==1 then II00IjLIOO=j1ojio elseif jo0iO0OjL10l==2 then II00IjLIOO=1/0 elseif jo0iO0OjL10l==3 then II00IjLIOO=-1/0 else II00IjLIOO=0/0 end
l0iojlj10i[lIjLIl1LI]=II00IjLIOO
return II00IjLIOO
end
local ljiOj1l1j01={}
local L0LO0LL=lL11iOolOOiO()
for iLi00oii0OiLIl=1,L0LO0LL do local j1LL0jioo1=lL11iOolOOiO() local jLl0IL0jL=lL11iOolOOiO() ljiOj1l1j01[j1LL0jioo1]=jLl0IL0jL end
local ILilLOLi=L11oOII1Il0(0)
if jo0li110jj~=#jL1I10ioj+1 then iIlOOL("VM trailing payload data",0) end
jL1I10ioj=nil
LoIoL1OLO1l0L=nil
local iiOo1liOoj0
local function jLil00j1jL0j(ILilLOLi,jOooIo)
return function(...) return iiOo1liOoj0(ILilLOLi,jOooIo,joLIii(...)) end
end
iiOo1liOoj0=function(ILilLOLi,jOooIo,ILl1lOoojL)
local ijOj01i1Oi1OL={}
local j1011jOo1OO0L0=0
local ILLoO0OII0i=ILilLOLi[1]
local jo1oi1Lj=ILl1lOoojL.n
for j1LL0jioo1=1,ILLoO0OII0i do ijOj01i1Oi1OL[j1LL0jioo1-1]=ILl1lOoojL[j1LL0jioo1] end
local j00jo1O,L0iioLLii={},0
if ILilLOLi[2]==1 then L0iioLLii=jo1oi1Lj-ILLoO0OII0i; if L0iioLLii<0 then L0iioLLii=0 end; for j1LL0jioo1=1,L0iioLLii do j00jo1O[j1LL0jioo1]=ILl1lOoojL[ILLoO0OII0i+j1LL0jioo1] end end
local I01j0iLi1,lLiIo01LoI1,ili1jOI=ILilLOLi[3],ILilLOLi[4],ILilLOLi[5]
local iiLl1OIL11=ILilLOLi[7]
local j1oiOiIjil1=1
local IL0ioIiloL1=0
while true do
local iOoOL1O1liIj=I01j0iLi1[j1oiOiIjil1]
if iOoOL1O1liIj==nil then iIlOOL("VM invalid instruction address",0) end
local l0o1ijIOll=(ILilLOLi[8]+j1oiOiIjil1*65599)%4294967296
j1oiOiIjil1=j1oiOiIjil1+1
l0o1ijIOll=(l0o1ijIOll*1664525+1013904223)%4294967296
local jI1Iiij1=(iOoOL1O1liIj[1]-l0o1ijIOll)%65536
l0o1ijIOll=(l0o1ijIOll*1664525+1013904223)%4294967296
local j1LL0jioo1=(iOoOL1O1liIj[2]-l0o1ijIOll)%65536
l0o1ijIOll=(l0o1ijIOll*1664525+1013904223)%4294967296
local jLl0IL0jL=(iOoOL1O1liIj[4]-l0o1ijIOll)%4294967296
l0o1ijIOll=(l0o1ijIOll*1664525+1013904223)%4294967296
local looolLIIoj=(iOoOL1O1liIj[3]-l0o1ijIOll)%4294967296
local LjjiI1iL0jIl1I=ljiOj1l1j01[jI1Iiij1]
if (LjjiI1iL0jIl1I*LjjiI1iL0jIl1I)%4==2 then j1011jOo1OO0L0=j1011jOo1OO0L0+1 end
if (LjjiI1iL0jIl1I*LjjiI1iL0jIl1I+LjjiI1iL0jIl1I)%2==1 then j1011jOo1OO0L0=j1011jOo1OO0L0-9 end
if (j1oiOiIjil1*(j1oiOiIjil1+1)*(j1oiOiIjil1+2))%3~=0 then j1011jOo1OO0L0=j1011jOo1OO0L0-6 end
if LjjiI1iL0jIl1I==7 then
local iOIIjjjojLlI=ijOj01i1Oi1OL[j1LL0jioo1]
local L1O0iI=ijOj01i1Oi1OL[j1LL0jioo1+1]
local jo0iO0OjL10l=ijOj01i1Oi1OL[j1LL0jioo1+2]
local i11lLIijLL0=joLIii(iOIIjjjojLlI(L1O0iI,jo0iO0OjL10l))
local jOL1ilILO1=i11lLIijLL0[1]
if jOL1ilILO1~=nil then
ijOj01i1Oi1OL[j1LL0jioo1+2]=jOL1ilILO1
for ljjoIj=1,jLl0IL0jL do ijOj01i1Oi1OL[j1LL0jioo1+3+ljjoIj-1]=i11lLIijLL0[ljjoIj] end
j1oiOiIjil1=looolLIIoj+1
end
elseif LjjiI1iL0jIl1I==10 then
ijOj01i1Oi1OL[j1LL0jioo1]=ijOj01i1Oi1OL[jLl0IL0jL]-ijOj01i1Oi1OL[looolLIIoj]
elseif LjjiI1iL0jIl1I==13 then
local j0oiIoiOLj
if jLl0IL0jL==0 then j0oiIoiOLj=IL0ioIiloL1-j1LL0jioo1-1 else j0oiIoiOLj=jLl0IL0jL end
local iOIIjjjojLlI=ijOj01i1Oi1OL[j1LL0jioo1]
for ljjoIj=1,j0oiIoiOLj do iOIIjjjojLlI[looolLIIoj+ljjoIj]=ijOj01i1Oi1OL[j1LL0jioo1+ljjoIj] end
elseif LjjiI1iL0jIl1I==12 then
ijOj01i1Oi1OL[j1LL0jioo1]=not ijOj01i1Oi1OL[jLl0IL0jL]
elseif LjjiI1iL0jIl1I==2 then
j1011jOo1OO0L0=(j1011jOo1OO0L0+jLl0IL0jL)%(looolLIIoj+1)
elseif LjjiI1iL0jIl1I==6 then
j1oiOiIjil1=jLl0IL0jL+1
elseif LjjiI1iL0jIl1I==39 then
ijOj01i1Oi1OL[jLl0IL0jL][1]=ijOj01i1Oi1OL[j1LL0jioo1]
elseif LjjiI1iL0jIl1I==32 then
ijOj01i1Oi1OL[j1LL0jioo1]=ioLo0io1ilj10[j1oOo1L(lLiIo01LoI1,iiLl1OIL11,jLl0IL0jL+1,ILilLOLi[9])]
elseif LjjiI1iL0jIl1I==3 then
local iOIIjjjojLlI=ijOj01i1Oi1OL[j1LL0jioo1]
local j0oiIoiOLj
if jLl0IL0jL==0 then j0oiIoiOLj=IL0ioIiloL1-j1LL0jioo1-1 else j0oiIoiOLj=jLl0IL0jL-1 end
local LOOL1IIol0OIj1={}
for ljjoIj=1,j0oiIoiOLj do LOOL1IIol0OIj1[ljjoIj]=ijOj01i1Oi1OL[j1LL0jioo1+ljjoIj] end
local i11lLIijLL0=joLIii(iOIIjjjojLlI(iIIILjLO(LOOL1IIol0OIj1,1,j0oiIoiOLj)))
if looolLIIoj==0 then
local jOL1ilILO1=i11lLIijLL0.n
for ljjoIj=1,jOL1ilILO1 do ijOj01i1Oi1OL[j1LL0jioo1+ljjoIj-1]=i11lLIijLL0[ljjoIj] end
IL0ioIiloL1=j1LL0jioo1+jOL1ilILO1
else
for ljjoIj=1,looolLIIoj-1 do ijOj01i1Oi1OL[j1LL0jioo1+ljjoIj-1]=i11lLIijLL0[ljjoIj] end
end
elseif LjjiI1iL0jIl1I==38 then
local ljjoIj=ijOj01i1Oi1OL[j1LL0jioo1]
if iIOo1L(ljjoIj)~=i1ILIOjOI1lL then
local iOIIjjjojLlI=ji10IIjOo(ljjoIj)
if iOIIjjjojLlI~=nil and iIOo1L(iOIIjjjojLlI)~=ljIoioo01 then iIlOOL("Protected iterator metatables require an explicit iterator function",0) end
local j0oiIoiOLj=iOIIjjjojLlI and L1iO1jLI(iOIIjjjojLlI,iOlllL1Lo)
if j0oiIoiOLj~=nil then
ijOj01i1Oi1OL[j1LL0jioo1],ijOj01i1Oi1OL[j1LL0jioo1+1],ijOj01i1Oi1OL[j1LL0jioo1+2]=j0oiIoiOLj(ljjoIj)
elseif iIOo1L(ljjoIj)==ljIoioo01 and (iOIIjjjojLlI==nil or L1iO1jLI(iOIIjjjojLlI,IIl0IO)==nil) then
ijOj01i1Oi1OL[j1LL0jioo1],ijOj01i1Oi1OL[j1LL0jioo1+1],ijOj01i1Oi1OL[j1LL0jioo1+2]=LL1IoIOj0oOol,ljjoIj,nil
end
end
elseif LjjiI1iL0jIl1I==34 then
ijOj01i1Oi1OL[j1LL0jioo1]=ijOj01i1Oi1OL[jLl0IL0jL]^ijOj01i1Oi1OL[looolLIIoj]
elseif LjjiI1iL0jIl1I==21 then
ijOj01i1Oi1OL[j1LL0jioo1]={ijOj01i1Oi1OL[jLl0IL0jL]}
elseif LjjiI1iL0jIl1I==23 then
ijOj01i1Oi1OL[j1LL0jioo1]=ijOj01i1Oi1OL[jLl0IL0jL]*ijOj01i1Oi1OL[looolLIIoj]
elseif LjjiI1iL0jIl1I==22 then
ijOj01i1Oi1OL[j1LL0jioo1]=j1oOo1L(lLiIo01LoI1,iiLl1OIL11,jLl0IL0jL+1,ILilLOLi[9])
elseif LjjiI1iL0jIl1I==27 then
ijOj01i1Oi1OL[j1LL0jioo1]=ijOj01i1Oi1OL[jLl0IL0jL][1]
elseif LjjiI1iL0jIl1I==29 then
ijOj01i1Oi1OL[j1LL0jioo1+1]=ijOj01i1Oi1OL[jLl0IL0jL]; ijOj01i1Oi1OL[j1LL0jioo1]=ijOj01i1Oi1OL[jLl0IL0jL][ijOj01i1Oi1OL[looolLIIoj]]
elseif LjjiI1iL0jIl1I==30 then
ijOj01i1Oi1OL[j1LL0jioo1]=(ijOj01i1Oi1OL[jLl0IL0jL]==ijOj01i1Oi1OL[looolLIIoj])
elseif LjjiI1iL0jIl1I==14 then
ijOj01i1Oi1OL[j1LL0jioo1][ijOj01i1Oi1OL[jLl0IL0jL]]=ijOj01i1Oi1OL[looolLIIoj]
elseif LjjiI1iL0jIl1I==28 then
local iOIIjjjojLlI=ili1jOI[jLl0IL0jL+1]
local LOOL1IIol0OIj1={}
local i11lLIijLL0=iOIIjjjojLlI[6]
for ljjoIj=1,#i11lLIijLL0 do
local jOL1ilILO1=i11lLIijLL0[ljjoIj]
if jOL1ilILO1[1]==1 then LOOL1IIol0OIj1[ljjoIj]=ijOj01i1Oi1OL[jOL1ilILO1[2]] else LOOL1IIol0OIj1[ljjoIj]=jOooIo[jOL1ilILO1[2]+1] end
end
ijOj01i1Oi1OL[j1LL0jioo1]=jLil00j1jL0j(iOIIjjjojLlI,LOOL1IIol0OIj1)
elseif LjjiI1iL0jIl1I==40 then
ijOj01i1Oi1OL[j1LL0jioo1]=(ijOj01i1Oi1OL[jLl0IL0jL]<=ijOj01i1Oi1OL[looolLIIoj])
elseif LjjiI1iL0jIl1I==41 then
ioLo0io1ilj10[j1oOo1L(lLiIo01LoI1,iiLl1OIL11,jLl0IL0jL+1,ILilLOLi[9])]=ijOj01i1Oi1OL[j1LL0jioo1]
elseif LjjiI1iL0jIl1I==36 then
ijOj01i1Oi1OL[j1LL0jioo1]=ijOj01i1Oi1OL[jLl0IL0jL]//ijOj01i1Oi1OL[looolLIIoj]
elseif LjjiI1iL0jIl1I==8 then
ijOj01i1Oi1OL[j1LL0jioo1]=(ijOj01i1Oi1OL[jLl0IL0jL]<ijOj01i1Oi1OL[looolLIIoj])
elseif LjjiI1iL0jIl1I==9 then
ijOj01i1Oi1OL[j1LL0jioo1]=ijOj01i1Oi1OL[jLl0IL0jL]+ijOj01i1Oi1OL[looolLIIoj]
elseif LjjiI1iL0jIl1I==20 then
jOooIo[jLl0IL0jL+1][1]=ijOj01i1Oi1OL[j1LL0jioo1]
elseif LjjiI1iL0jIl1I==17 then
local j0oiIoiOLj
if jLl0IL0jL==0 then j0oiIoiOLj=IL0ioIiloL1-j1LL0jioo1 else j0oiIoiOLj=jLl0IL0jL-1 end
local LOOL1IIol0OIj1={}
for ljjoIj=1,j0oiIoiOLj do LOOL1IIol0OIj1[ljjoIj]=ijOj01i1Oi1OL[j1LL0jioo1+ljjoIj-1] end
return iIIILjLO(LOOL1IIol0OIj1,1,j0oiIoiOLj)
elseif LjjiI1iL0jIl1I==43 then
ijOj01i1Oi1OL[j1LL0jioo1]=ijOj01i1Oi1OL[jLl0IL0jL]/ijOj01i1Oi1OL[looolLIIoj]
elseif LjjiI1iL0jIl1I==42 then
if (not not ijOj01i1Oi1OL[j1LL0jioo1])==(jLl0IL0jL~=0) then j1oiOiIjil1=looolLIIoj+1 end
elseif LjjiI1iL0jIl1I==16 then
ijOj01i1Oi1OL[j1LL0jioo1]=#ijOj01i1Oi1OL[jLl0IL0jL]
elseif LjjiI1iL0jIl1I==19 then
if jLl0IL0jL==0 then
for ljjoIj=1,L0iioLLii do ijOj01i1Oi1OL[j1LL0jioo1+ljjoIj-1]=j00jo1O[ljjoIj] end
IL0ioIiloL1=j1LL0jioo1+L0iioLLii
else
for ljjoIj=1,jLl0IL0jL-1 do ijOj01i1Oi1OL[j1LL0jioo1+ljjoIj-1]=j00jo1O[ljjoIj] end
end
elseif LjjiI1iL0jIl1I==4 then
ijOj01i1Oi1OL[j1LL0jioo1]=(ijOj01i1Oi1OL[jLl0IL0jL]>=ijOj01i1Oi1OL[looolLIIoj])
elseif LjjiI1iL0jIl1I==18 then
ijOj01i1Oi1OL[j1LL0jioo1]=(ijOj01i1Oi1OL[jLl0IL0jL]~=ijOj01i1Oi1OL[looolLIIoj])
elseif LjjiI1iL0jIl1I==31 then
for ljjoIj=j1LL0jioo1,j1LL0jioo1+2 do
ijOj01i1Oi1OL[ljjoIj]=j01OlooOLOij11(ijOj01i1Oi1OL[ljjoIj])
if ijOj01i1Oi1OL[ljjoIj]==nil then iIlOOL("Numeric for bounds and step must be numbers",0) end
end
local iOIIjjjojLlI=ijOj01i1Oi1OL[j1LL0jioo1+2]
local j0oiIoiOLj
if iOIIjjjojLlI>0 then j0oiIoiOLj=ijOj01i1Oi1OL[j1LL0jioo1]<=ijOj01i1Oi1OL[j1LL0jioo1+1] else j0oiIoiOLj=ijOj01i1Oi1OL[j1LL0jioo1]>=ijOj01i1Oi1OL[j1LL0jioo1+1] end
if j0oiIoiOLj then ijOj01i1Oi1OL[j1LL0jioo1+3]=ijOj01i1Oi1OL[j1LL0jioo1] else j1oiOiIjil1=jLl0IL0jL+1 end
elseif LjjiI1iL0jIl1I==25 then
ijOj01i1Oi1OL[j1LL0jioo1]=-ijOj01i1Oi1OL[jLl0IL0jL]
elseif LjjiI1iL0jIl1I==1 then
ijOj01i1Oi1OL[j1LL0jioo1]={}
elseif LjjiI1iL0jIl1I==33 then
ijOj01i1Oi1OL[j1LL0jioo1]=ijOj01i1Oi1OL[jLl0IL0jL]
elseif LjjiI1iL0jIl1I==26 then
ijOj01i1Oi1OL[j1LL0jioo1]=ijOj01i1Oi1OL[jLl0IL0jL]..ijOj01i1Oi1OL[looolLIIoj]
elseif LjjiI1iL0jIl1I==35 then
ijOj01i1Oi1OL[j1LL0jioo1]=ijOj01i1Oi1OL[j1LL0jioo1]+ijOj01i1Oi1OL[j1LL0jioo1+2]
local iOIIjjjojLlI=ijOj01i1Oi1OL[j1LL0jioo1+2]
local j0oiIoiOLj
if iOIIjjjojLlI>0 then j0oiIoiOLj=ijOj01i1Oi1OL[j1LL0jioo1]<=ijOj01i1Oi1OL[j1LL0jioo1+1] else j0oiIoiOLj=ijOj01i1Oi1OL[j1LL0jioo1]>=ijOj01i1Oi1OL[j1LL0jioo1+1] end
if j0oiIoiOLj then ijOj01i1Oi1OL[j1LL0jioo1+3]=ijOj01i1Oi1OL[j1LL0jioo1]; j1oiOiIjil1=jLl0IL0jL+1 end
elseif LjjiI1iL0jIl1I==5 then
ijOj01i1Oi1OL[j1LL0jioo1]=(jLl0IL0jL~=0)
elseif LjjiI1iL0jIl1I==37 then
ijOj01i1Oi1OL[j1LL0jioo1]=(ijOj01i1Oi1OL[jLl0IL0jL]>ijOj01i1Oi1OL[looolLIIoj])
elseif LjjiI1iL0jIl1I==11 then
ijOj01i1Oi1OL[j1LL0jioo1]=jOooIo[jLl0IL0jL+1][1]
elseif LjjiI1iL0jIl1I==15 then
ijOj01i1Oi1OL[j1LL0jioo1]=ijOj01i1Oi1OL[jLl0IL0jL][ijOj01i1Oi1OL[looolLIIoj]]
elseif LjjiI1iL0jIl1I==24 then
ijOj01i1Oi1OL[j1LL0jioo1]=ijOj01i1Oi1OL[jLl0IL0jL]%ijOj01i1Oi1OL[looolLIIoj]
elseif LjjiI1iL0jIl1I==44 then
for ljjoIj=j1LL0jioo1,j1LL0jioo1+jLl0IL0jL do ijOj01i1Oi1OL[ljjoIj]=nil end
else iIlOOL() end
end
return j1011jOo1OO0L0
end
return iiOo1liOoj0(ILilLOLi,{},joLIii(...))
