import java.awt.*;
import java.applet.*;

class FoilShape extends Panel {

	double angle;
	Vortex root;

	public FoilShape(Vortex root1) {
		super();
		root=root1;
	}

	public void paint(Graphics g) {
		drawAngle(g);
		drawFoil(g);
	}

	private void drawAngle(Graphics g) {
		g.setColor(Color.darkGray);
		drawArrow(50,0,0,50,size().height-50,0.0,g);
		drawArrow(50,0,0,50,size().height-50,Math.PI/2,g);		
		drawArrow(50,9,6,50,size().height-50,root.angle,g);
		g.drawString("Angle of attack",10,size().height-5);
	}

	private void drawFoil(Graphics g) {
		int x1,y1,x2,y2;

		if(root.nPts>1){
			for(int i=1;i<=root.nPts;i++) {
				x2=(int)Math.round(root.xList[i]*size().width*.8+size().width*.1);
				y2=(int)Math.round(-root.yList[i]*size().width*.8+size().height/2);
				g.setColor(Color.red);
				g.drawOval(x2-2,y2-2,4,4);
				if(i>1) {
					x1=(int)Math.round(root.xList[i-1]*size().width*.8+size().width*.1);
					y1=(int)Math.round(-root.yList[i-1]*size().width*.8+size().height/2);
					g.setColor(Color.blue);
					g.drawLine(x1,y1,x2,y2);
				}
			}
		}
	}

	  private void drawArrow(int shaftLength, int headLength, int headWidth, int xPos, int yPos, double angle, Graphics ga) {
      int xa,ya,xb,yb,xc,yc,xd,yd;

      xa=xPos-(int)Math.round(shaftLength/2.0*Math.cos(angle));
      ya=yPos+(int)Math.round(shaftLength/2.0*Math.sin(angle));
      xb=xa+(int)Math.round(shaftLength*Math.cos(angle));
      yb=ya-(int)Math.round(shaftLength*Math.sin(angle));
      xc=xa+(int)Math.round((shaftLength-headLength)*Math.cos(angle)-headWidth/2.0*Math.sin(angle));
      yc=ya-(int)Math.round((shaftLength-headLength)*Math.sin(angle)+headWidth/2.0*Math.cos(angle));
      xd=xa+(int)Math.round((shaftLength-headLength)*Math.cos(angle)+headWidth/2.0*Math.sin(angle));
      yd=ya-(int)Math.round((shaftLength-headLength)*Math.sin(angle)-headWidth/2.0*Math.cos(angle));

      ga.drawLine(xa,ya,xb,yb);
      ga.drawLine(xb,yb,xc,yc);
      ga.drawLine(xb,yb,xd,yd);
    }

}