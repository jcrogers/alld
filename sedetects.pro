function sedetects

datfile='~/include/sed.csv'
psoutf ='se_detections.ps'

readcol, datfile, plname, plcode, band, bandw, depth, deu, del, $
         f='(a,a,a,f,f,f,f)', /silent


uniqp = plcode[uniq(plcode)]
nup = n_elements(uniqp)


psopen, psoutf
pa=pastruct()

xt=textoidl('Wavelength (\mum)')
yt=textoidl('Eclipse Depth (%)')
xr=[0.5,25]

bnames = ['z','J','H','Ks','IRAC']
bcolors = ['purple','blue','dk.green','orange','red','red','red','red']
bcolornos = [13,4,18,8,2]
bwls=[.9,1.25,1.65,2.15,3.6,4.5,5.8,8]
nbn=n_elements(bwls)

;Plot all of them
!p.multi=[0,1,2]
  yr=[0,max(depth+deu)]
  plot, bandw, depth, psym=4, /xlog, xrange=xr,/xstyle, yrange=yr,/ystyle,$
        title=textoidl('All Sec. Ecl. Detections'), xtitle=xt, ytitle=yt
  for bi=0,nbn-1 do joplot, [bwls[bi],bwls[bi]], yr, stype=0,thk1=8, color=bcolors[bi]
  plot, bandw, depth, psym=4, /xlog, xrange=xr,/xstyle, yrange=yr,/ystyle,$
        title=textoidl('All Sec. Ecl. Detections'), xtitle=xt, ytitle=yt
  for bi=0,nbn-1 do joplot, [bwls[bi],bwls[bi]], yr, stype=0,thk1=8, color=bcolors[bi]
  oploterror, bandw, depth, del, /lobar, psym=4               
  oploterror, bandw, depth, deu, /hibar, psym=4
  legend, /top, /left, bnames, color=bcolornos, linestyle=0, thick=8

nsed=intarr(nup)

!p.multi=[0,2,4]

;Plot and print each one
print, 'Planet       Bands Observed'
print, '---------------------------'

for upi=0,nup-1 do begin
  tp=where(plcode eq uniqp(upi),ntp)
  nsed[upi]=ntp
  tpband=band[tp]
  if ntp gt 1 then begin
    yr=[0,max(depth[tp]+deu[tp])]
    plot, bandw[tp], depth[tp], psym=4, /xlog, xrange=xr, /xstyle, yrange=yr,/ystyle,$
          title=plname[tp[0]], xtitle=xt, ytitle=yt
    for bi=0,nbn-1 do joplot, [bwls[bi],bwls[bi]], yr, stype=0,thk1=8, color=bcolors[bi]
    oploterror, bandw[tp], depth[tp], del[tp], /lobar, psym=4               
    oploterror, bandw[tp], depth[tp], deu[tp], /hibar, psym=4
    bandst=tpband[0]
    for ti=1,ntp-1 do bandst=bandst+', '+tpband[ti]
    print, plname[tp[0]],'   ', bandst, f='(a10,a3,a)'
  endif
endfor



psclose
stop

return, 0
end
