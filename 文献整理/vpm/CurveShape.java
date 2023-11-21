import java.awt.*;

class CurveShape extends Panel{

	private boolean firstPass,isDraw;
	private double[] alpha;//,ypix2;
	private boolean isCP,isDeg;
	Vortex root;

	public CurveShape(Vortex root1) {
		super();
		root=root1;
	}

	public void paint(Graphics g) {

		if(root.unitsChoice.getSelectedIndex()<2) drawCP(g);
		else drawCLM(g);
	}

	public void drawCP(Graphics g) {
		int x1,y1,x2,y2;

		Axis(0.001,1.00001,(int)Math.round(size().width*.1)
			                ,(int)Math.round(size().height*(0.9-1./7.*.8))
							,(int)Math.round(size().width*.9)
							,(int)Math.round(size().height*(0.9-1./7.*.8))
							,2,true,g,new Font("TimesRoman",Font.ITALIC,10));
		Axis(-1.00001,6.00001,(int)Math.round(size().width*.1)
			                 ,(int)Math.round(size().height*0.9)
							 ,(int)Math.round(size().width*.1)
							 ,(int)Math.round(size().height*0.1)
							 ,-2,true,g,new Font("TimesRoman",Font.ITALIC,10));

		g.setFont(new Font("TimesRoman",Font.ITALIC,12));
		g.setColor(Color.red);
		g.drawString("-Cp",(int)Math.round(0)
			              ,(int)Math.round(size().height*(0.9-6./7.*.8)));
		g.setColor(Color.black);
		g.drawString("x",(int)Math.round(size().width*.85)
			            ,(int)Math.round(size().height*0.9));

		g.setColor(Color.gray);
		g.drawString("Cl = "+format(root.cl[0]),(int)Math.round(size().width*.65),(int)Math.round(size().height*.18));
		g.drawString("Cm = "+format(root.cm[0]),(int)Math.round(size().width*.65),(int)Math.round(size().height*.25));

		if ((root.nPts > 1)&&(root.cpdone)) {
			for(int i=1;i<root.nPts;i++) {
				x2=(int)Math.round(root.airFoil.x[i]*size().width*.8+size().width*.1);
				y2=(int)Math.round(size().height*.9-(-root.airFoil.cp[i]+1.)/7.0*size().height*.8);
				g.setColor(Color.red);
				g.drawOval(x2-2,y2-2,4,4);
			}
		}

	}
	public void drawCLM(Graphics g) {
		int x1,y1,y1m;
		double amax,amin,clmax=0.,clmin=0.;

		if (root.cldone) {
			clmax=0.0;clmin=0.0;
			for(int i=1;i<=root.nAngleSteps+1;i++) {
				if(root.cl[i]>clmax) clmax=root.cl[i];
				if(root.cl[i]<clmin) clmin=root.cl[i];
				if(root.cm[i]>clmax) clmax=root.cm[i];
				if(root.cm[i]<clmin) clmin=root.cm[i];
			}
		}
		else {
			clmin=-1.0;clmax=1.0;
		}

		amin=-root.angle;amax=root.angle;
		if(root.unitsChoice.getSelectedIndex()==2) {
			amax*=180/3.14159;amin*=180/3.14159;
		}

		Axis(amin,amax,(int)Math.round(size().width*.1)
			          ,(int)Math.round(size().height*(0.9+clmin/(clmax-clmin)*.8))
					  ,(int)Math.round(size().width*.9)
					  ,(int)Math.round(size().height*(0.9+clmin/(clmax-clmin)*.8))
					  ,2,true,g,new Font("TimesRoman",Font.ITALIC,10));
		Axis(clmin,clmax,(int)Math.round(size().width*(.1-amin/(amax-amin)*.8))
			          ,(int)Math.round(size().height*0.9)
					  ,(int)Math.round(size().width*(.1-amin/(amax-amin)*.8))
					  ,(int)Math.round(size().height*0.1)
					  ,-2,true,g,new Font("TimesRoman",Font.ITALIC,10));

		if(root.unitsChoice.getSelectedIndex()==2) {
			amax*=3.14159/180.;amin*=3.14159/180.;
		}

		g.setColor(Color.blue);
		g.setFont(new Font("TimesRoman",Font.ITALIC,12));
		g.drawString("Cl",(int)Math.round(size().width*(-0.8*amin/(amax-amin)-.05)),(int)Math.round(size().height*(0.9-6./7.*.8)));
		g.setColor(Color.red);
		g.drawString("Cm",(int)Math.round(size().width*(-0.8*amin/(amax-amin)-.05)),(int)Math.round(size().height*(0.9-5./7.*.8)));
		g.setColor(Color.black);
		g.drawString("alpha",(int)Math.round(size().width*.85)
			            ,(int)Math.round(size().height*(0.9+clmin/(clmax-clmin)*.8+.1)));

		if (root.cldone) {
			for(int i=1;i<=root.nAngleSteps+1;i++) {
				x1=(int)Math.round((root.alpha[i]-amin)/(amax-amin)*size().width*.8+size().width*.1);
				y1=(int)Math.round(size().height*.9-(root.cl[i]-clmin)/(clmax-clmin)*size().height*.8);
				y1m=(int)Math.round(size().height*.9-(root.cm[i]-clmin)/(clmax-clmin)*size().height*.8);
				g.setColor(Color.blue);
				g.drawOval(x1-2,y1-2,4,4);
				g.setColor(Color.red);
				g.drawLine(x1-2,y1m,x1+2,y1m);g.drawLine(x1,y1m-2,x1,y1m+2);
			}
		}

	}

	public void Axis(double al,double ah,int axl,int ayl,int axh,int ayh,int tl,boolean tickside, Graphics g, Font f) {
		// al,ah;		     Limits of axis */
		// axl,axh,ayl,ayh;	 Starting and stopping coordinates of axis in pixels */
		// tl,ch;		     Tick length in pixels, character height in points */


		 double v,as;
		 int xc,yc,lblw,xt,yt,xx,yy,i,il,ih,mag,del,min,maj,ang,p;
		 boolean xaxis,yaxis;
		 String lbl;
		 FontMetrics fm=getFontMetrics(f);

		 g.drawLine(axl,ayl,axh,ayh);   /* Draw axis line */

		 mag=wg_int(Math.log(Math.abs(ah-al))/Math.log(10.0));
		 del=wg_int(ah/Math.pow(10.0,(double)mag)-al/Math.pow(10.0,(double)mag));
		 if(del<2) {min=20;maj=5;}
		 else if(del<5) {min=10;maj=2;}
		 else {min=5;maj=1;}

		 as=Math.sqrt(Math.pow(ayh-ayl,2)+Math.pow(axh-axl,2));
		 xaxis=false;if(ayh-ayl==0) xaxis=true;
		 yaxis=false;if(axh-axl==0) yaxis=true;


		 il=wg_int(al/Math.pow(10.0,(double)mag)*(double)(min)+.9999);
		 ih=wg_int(ah/Math.pow(10.0,(double)mag)*(double)(min));
		 for(i=il;i<=ih;i++) {	   /* Minor ticks */
			   v=(double)i/(double)min*Math.pow(10.0,(double)mag);
			   xx=(int)Math.round(axl+(axh-axl)*(v-al)/(ah-al));
			   yy=(int)Math.round(ayl+(ayh-ayl)*(v-al)/(ah-al));
			   xt=xx-(int)Math.round(tl*(ayh-ayl)/as);
			   yt=yy+(int)Math.round(tl*(axh-axl)/as);
			   g.drawLine(xx,yy,xt,yt);
		 }

		 il=wg_int(al/Math.pow(10.0,(double)mag)*(double)(maj)+.9999);
		 ih=wg_int(ah/Math.pow(10.0,(double)mag)*(double)(maj));
		 for(i=il;i<=ih;i++) {	   /* Major ticks */
			   v=(double)i/(double)maj*Math.pow(10.0,(double)mag);
			   xx=(int)Math.round(axl+(axh-axl)*(v-al)/(ah-al));
			   yy=(int)Math.round(ayl+(ayh-ayl)*(v-al)/(ah-al));
			   xt=xx-(int)Math.round(2.0*tl*(ayh-ayl)/as);
			   yt=yy+(int)Math.round(2.0*tl*(axh-axl)/as);
			   g.drawLine(xx,yy,xt,yt);		  /* Draw tick */

			   lbl=format(v);xc=xt;yc=yt;

			   if(xaxis) {
				   xc=xt-fm.stringWidth(lbl)/2;
				   if(yt>yy) {
					   if(tickside) yc=yt+fm.getHeight();
					   else yc=yy-fm.getHeight()+fm.getAscent();
				   }
				   else {
					   if(tickside) yc=yt-fm.getHeight()+fm.getAscent();
					   else yc=yy+fm.getHeight();
				   }
			   }

			   if(yaxis) {
				   yc=yt+fm.getAscent()/2;
				   if(xt>xx) {
					   if(tickside) xc=xt+fm.getHeight()/2;
					   else xc=xx-fm.stringWidth(lbl)-fm.getHeight()/2;
				   }
				   else {
					   if(tickside) xc=xt-fm.stringWidth(lbl)-fm.getHeight()/2;
					   else xc=xx+fm.getHeight()/2;
				   }
			   }

			   g.setFont(f);

			   g.drawString(lbl,xc,yc);
		 }
	}


	public int wg_int(double fl) { // Method to truncate a double to an integer - proper handling of negative #'s

		if(fl>=0.0) return((int)fl);
		else return((int)(fl-.999999));
	}



    String format(double d) {
        String out="",buf;
        String[] zeros={"0.","0.0","0.00"};
        int mant,exp,sgn=1;
        int fdigits=7;         //number of digits to show in floating-point format
        int sdigits=4;         //number of digits to show in scientific format
        int sci=4;            //absolute magnitude of numbers below which to display floating-point format

        if(d>0.0) sgn=1;
        else if(d<0.0) sgn=-1;
        else return("0.0");

        d=Math.abs(d);
        exp=(int)(Math.log(d*1.0000001)/Math.log(10));
        if(d<1.0) exp--;

        if(exp<4 & exp>=0) {
            mant=(int)Math.round(d*Math.pow(10.,(double)(fdigits-1-exp)));
            buf=String.valueOf(mant);
            out=buf.substring(0,buf.length()-fdigits+exp+1)+"."+buf.substring(buf.length()-fdigits+exp+1); //insert point
            while(out.lastIndexOf("0")==out.length()-1) out=out.substring(0,out.length()-1); //strip trailing zeros
            if(out.lastIndexOf(".")==out.length()-1) out=out.substring(0,out.length()-1);   //strip trailing point if necessary
            if(sgn==-1) out="-"+out;
        }
        else if(exp<0 & exp>-4) {
            mant=(int)Math.round(d*Math.pow(10.,(double)(fdigits-1)));
            buf=String.valueOf(mant);
            out=zeros[-exp-1]+buf; //insert point
            while(out.lastIndexOf("0")==out.length()-1) out=out.substring(0,out.length()-1); //strip trailing zeros
            if(sgn==-1) out="-"+out;
        }
        else {
            mant=(int)Math.round(d*Math.pow(10.,(double)(sdigits-1-exp)));
            buf=String.valueOf(mant);
            out=buf.substring(0,1)+"."+buf.substring(1); //insert point
            while(out.lastIndexOf("0")==out.length()-1) out=out.substring(0,out.length()-1); //strip trailing zeros
            if(out.lastIndexOf(".")==out.length()-1) out=out.substring(0,out.length()-1);   //strip trailing point if necessary
            if(sgn==-1) out="-"+out;
            if(exp>0) out=out+"e+"+String.valueOf(exp);
            else out=out+"e"+String.valueOf(exp);
        }
        return(out);

    }

}




