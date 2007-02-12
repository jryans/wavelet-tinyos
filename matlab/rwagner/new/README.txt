This .zip file contains code necessary to implement the distributed,
irregular grid wavelet transform desribed in "Approximation and 
Compression of Scattered Data by Meshless Multiscale Decompositions"
by R. Baraniuk, A. Cohen, and R. Wagner (in preparation, and a 
modificiaton of the algorithm described in "An Architecture for 
Distributed Wavelet Analysis and Processing in Sensor Networks" by 
R. Wagner, R. Baraniuk, S. Du, D.B. Johnson, and A. Cohen, IPSN, 
April, 2006). 

The main file is trangen2d.m, which takes an Nx2 matrix of 
[0,1]x[0,1] data point coordinates and returns a struct TRANDATA
containing the parameters for the wavelet lifting transform. 
The forward transform is implemented in dwtmeshless.m and takes 
TRANDATA and an Nx1 vector of data values assigned to the N 
coordinates and returns an Nx1 vector of transform coefficients.  
The inverse transform is implemented in idwtmeshless.m and takes
an Nx1 vector of transform coefficients and TRANDATA and returns
an Nx1 vector of spatial values.

The data contained in TRANDATA is as follows:

trandata{1}      -   Nx1 vector indicating scale of each 
		     point's wavelet coefficient. 

trandata{2}	 -   struct of N elements, each a list of
		     node ID's of neighbors used by node n to                                                 
		     compute its wavelet coefficient. 

trandata{3}	 -   struct matching predneighbs containing
		     predict coefficient for each neighbor.

trandtata{4}     -  struct of N elements, each a struct
		    of J elements where J=max(scales). 
           	    upneighbs{n}{j} gives the neighbors which 
		    update node n at scale j --- i.e., those
		    neighbors node n helps predict.

trandata{5}      -  struct matching upneighbs containing update
		    coefficient for each neighbor.

trandata{6}      -  overall transform matrix, which implements
		    all sclaes of the lifting transform with a
                    single matrix multiply.


As an example:

N=100;
coords=rand(N,2);
vals=rand(N,1);
trandata=trangen2d(coords);
tranvals=dwtmeshless(vals,trandata);
valshat=idwtmeshless(tranvals,trandata);

Call help on each function for more information.

Raymond S. Wagner (rwagner@rice.edu)
Rice University
last rev:  10/10/2006



