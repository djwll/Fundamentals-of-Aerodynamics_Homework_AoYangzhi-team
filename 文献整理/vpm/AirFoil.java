import java.awt.*;
import java.applet.*;
import java.lang.*;

class AirFoil {

	double[] xb,yb,x,y,s,theta,v,cp,gamma,rhs;
	double[][] cn1,cn2,ct1,ct2,an,at;
	int[] indx;
	int m,mp1,si;
	double pi,sx,sy;

	public AirFoil(double[] xList,double[] yList,int nPts) {

		m = nPts-1;
		mp1 = m+1;

		pi = 4.0 * Math.atan(1.0);

		x = new double[m+2];
		y = new double[m+2];
		s = new double[m+2];
		theta = new double[m+2];
		v = new double[m+2];
		cp = new double[m+2];
		gamma = new double[m+2];
		rhs = new double[m+2];
		cn1 = new double[m+2][m+2];
		cn2 = new double[m+2][m+2];
		ct1 = new double[m+2][m+2];
		ct2 = new double[m+2][m+2];
		an = new double[m+2][m+2];
		at = new double[m+2][m+2];

		xb = xList;
		yb = yList;

		calcXYST(); 
		calcCNTs();
		calcANTs();

		indx = new int[mp1+2];
		ludcmp(an,mp1,indx);

	}

	public void computeValues(double alpha) {
		for(int i=1;i<=m;i++) rhs[i] = Math.sin(theta[i]-alpha);
		rhs[m+1]=0.0;
		gamma = lubksb(an,mp1,indx,rhs);
		for(int i=1;i<=m;i++) {
			v[i] = Math.cos(theta[i]-alpha);
			for(int j=1;j<=mp1;j++) {
				v[i] += at[i][j]*gamma[j];
				cp[i] = 1.0 - v[i]*v[i];
			}
		}
	}

	public boolean getStagPt() {
		for(int i=1;i<m;i++) {
			if (v[i]*v[i+1]<=0.0) {
				sx = -v[i] * (x[i+1]-x[i])/(v[i+1]-v[i]) + x[i];
				sy = -v[i] * (y[i+1]-y[i])/(v[i+1]-v[i]) + y[i];
				si = i+1;
				return true;
			}
		}
		return false;
	}

	private void calcXYST() {

		int ip1;
		for(int i=1;i<=m;i++) {
			ip1 = i + 1;
			x[i] = 0.5 * (xb[i] + xb[ip1] );
			y[i] = 0.5 * (yb[i] + yb[ip1]);
			double xDiff = xb[ip1] - xb[i];
			double yDiff = yb[ip1] - yb[i];
			s[i] = Math.sqrt( xDiff*xDiff + yDiff*yDiff);
			theta[i] = Math.atan2(yDiff,xDiff);
		}
	}

	private void calcCNTs() {
		double a,b,c,d,e,f,g,p,q;

		for(int i=1;i<=m;i++) {
			for(int j=1;j<=m;j++) {
				if(i!=j) {
					a = -(x[i]-xb[j]) * Math.cos(theta[j])- (y[i]-yb[j]) * Math.sin(theta[j]);
					b = (x[i]-xb[j])*(x[i]-xb[j]) + (y[i]-yb[j])*(y[i]-yb[j]);
					c = Math.sin(theta[i] - theta[j]);
					d = Math.cos(theta[i] - theta[j]);
					e = (x[i]-xb[j])*Math.sin(theta[j]) - (y[i]-yb[j])*Math.cos(theta[j]);
					f = Math.log(1.0 + s[j]*(s[j]+2.0*a)/b);
					g = Math.atan2( e*s[j], b+a*s[j]);
					p = (x[i]-xb[j]) * Math.sin(theta[i]-2.0*theta[j]) + (y[i]-yb[j]) * Math.cos(theta[i]-2.0*theta[j]);
					q = (x[i]-xb[j]) * Math.cos(theta[i]-2.0*theta[j] ) - (y[i]-yb[j]) *Math.sin(theta[i]-2.0*theta[j]);
					cn2[i][j] = d + 0.5*q*f/s[j] - (a*c+d*e)*g/s[j];
					cn1[i][j] = 0.5*d*f + c*g - cn2[i][j];
					ct2[i][j] = c + 0.5*p*f/s[j] + (a*d-c*e)*g/s[j];
					ct1[i][j] = 0.5*c*f - d*g - ct2[i][j];
				}
				else {
					cn1[i][j] = -1.0;
					cn2[i][j] = 1.0;
					ct1[i][j] = 0.5*pi;
					ct2[i][j] = 0.5*pi;
				}
			}
		}
	}

	private void calcANTs() {

		for(int i=1;i<=m;i++) {
			an[i][1] = cn1[i][1];
			an[i][mp1] = cn2[i][m];
			at[i][1] = ct1[i][1];
			at[i][mp1] = ct2[i][m];
			for(int j=2;j<=m;j++) {
				an[i][j] = cn1[i][j] + cn2[i][j-1];
				at[i][j] = ct1[i][j] + ct2[i][j-1];
			}
		}
		an[mp1][1] = 1.0;
		an[mp1][mp1] = 1.0;
		for(int j=2;j<=m;j++)
			an[mp1][j] = 0.0;
	}

	private boolean ludcmp(double[][] a,int n,int[] indx) {
		int i,imax=0,j,k;
		double big,dum,sum,temp,TINY=0.0000000000001,d;
		double[] vv;

		vv = new double[n+2];
		d = 1.0;
		for(i=1;i<=n;i++) {
			big = 0.0;
			for(j=1;j<=n;j++)
				if((temp = Math.abs(a[i][j])) > big) big = temp;
			if(big==0.0) return false;
			vv[i] = 1.0/big;
		}
		for(j=1;j<=n;j++) {
			for(i=1;i<j;i++) {
				sum = a[i][j];
				for(k=1;k<i;k++)
					sum -= a[i][k]*a[k][j];
				a[i][j] = sum;
			}
			big = 0.0;
			for(i=j;i<=n;i++) {
				sum = a[i][j];
				for(k=1;k<j;k++)
					sum -= a[i][k]*a[k][j];
				a[i][j] = sum;
				if((dum=vv[i]*Math.abs(sum)) >= big) {
					big = dum;
					imax = i;
				}
			}
			if(j!= imax) {
				for(k=1;k<=n;k++) {
					dum = a[imax][k];
					a[imax][k] = a[j][k];
					a[j][k] = dum;
				}
				d = -d;
				vv[imax] = vv[j];
			}
			indx[j] = imax;
			if(a[j][j] == 0.0) a[j][j] = TINY;
			if(j!=n) {
				dum = 1.0/(a[j][j]);
				for(i=j+1;i<=n;i++) a[i][j] *= dum;
			}
		}
		return true;
	}

		private double[] lubksb(double[][] a,int n,int[] indx,double[] b) {
			int i,ii=0,ip,j;
			double sum;
			double[] gam= new double[mp1+2];

			for(i=1;i<=n;i++) {
				ip = indx[i];
				sum = b[ip];
				b[ip] = b[i];
				if(ii!=0)
					for(j=ii;j<=i-1;j++)
						sum -= a[i][j]*b[j];
				else if(sum!=0)
					ii = i;
				b[i] = sum;
			}
			for(i=n;i>=1;i--) {
				sum = b[i];
				for(j=i+1;j<=n;j++)
					sum -= a[i][j]*b[j];
				b[i] = sum/a[i][i];
			}
			return b;
		}

}
