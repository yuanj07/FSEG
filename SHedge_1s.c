# include "math.h"
# include "mex.h"

# define BinN 11 /* bin number */

float x2dist(float *a, float *b, int k)
{
	int i;
	float  T;
	T=0;
	for (i=0; i<k; i++){
		if (a[i]+b[i]!=0){
			T=T+(a[i]-b[i])*(a[i]-b[i])/(a[i]+b[i]);}
	}
	return T;
}

float l2dist(float *a, float *b, int k)
{
	int i;
	float  T;
	T=0;
	for (i=0; i<k; i++){
        T=T+(a[i]-b[i])*(a[i]-b[i]);
	}
	return T;
}


int maxNum(int a, int b)
{
	if (a>b) return a;
	else return b;
}

int minNum(int a, int b)
{
	if (a>b) return b;
	else return a;
}

void mexFunction(    
    int nargout,
    mxArray *out[],
    int nargin,
    const mxArray *in[]
)
{
    int N1, N2, dn, ws, dism;
    int i, j, b, k;
    int ndim, *dims;
	float *up, *bt, *lf, *rt;   
    float *EdgeMap, *sh_mx;
 
  
    /* check argument */
    if (nargin < 3) {
        mexErrMsgTxt("Three input arguments required");
    }
    if (nargout> 1) {
        mexErrMsgTxt("Too many output arguments.");
    }

    ws = mxGetScalar(in[0]);
    dism = mxGetScalar(in[1]);
    sh_mx = mxGetData(in[2]);
    dims = mxGetDimensions(in[2]);
   
    ndim = 3;
    dn = dims[0];
    N1 = dims[1];
    N2 = dims[2];

    out[0] = mxCreateNumericMatrix(N1, N2, mxSINGLE_CLASS, mxREAL);
    /*out[1] = mxCreateNumericArray(ndim, dims, mxSINGLE_CLASS, mxREAL);*/
	/*out[1] = mxCreateNumericMatrix(BinN,1, mxSINGLE_CLASS,mxREAL);*/

    if (out[0]==NULL) {
	    mexErrMsgTxt("Not enough memory for the output matrix 1");
	}

    EdgeMap = mxGetData(out[0]);
    /*HImap = mxGetPr(out[1]);*/
	/*binc = mxGetPr(out[1]);*/
     
 
    /* Compute Edgeness */

	up = mxCalloc(dn, sizeof(float));
	bt = mxCalloc(dn, sizeof(float));
	rt = mxCalloc(dn, sizeof(float));
	lf = mxCalloc(dn, sizeof(float));

	for (i=0; i<N1; i++){
		for (j=0; j<N2; j++) {
			for (k=0; k<dn; k++){
				up[k]=sh_mx[k+maxNum(0,i-ws)*dims[0]+j*dims[0]*dims[1]];
			}
			for (k=0; k<dn; k++){
				bt[k]=sh_mx[k+minNum(N1-1,i+ws)*dims[0]+j*dims[0]*dims[1]];
			}
			for (k=0; k<dn; k++){
				lf[k]=sh_mx[k+i*dims[0]+maxNum(0,j-ws)*dims[0]*dims[1]];
			}
			for (k=0; k<dn; k++){
				rt[k]=sh_mx[k+i*dims[0]+minNum(N2-1,j+ws)*dims[0]*dims[1]];
			}
            if (dism == 1)
			EdgeMap[i+j*N1]=x2dist(up,bt,dn)+x2dist(lf,rt,dn);
            else
            EdgeMap[i+j*N1]=sqrtf(l2dist(up,bt,dn)+l2dist(lf,rt,dn));
			}
		}
}







