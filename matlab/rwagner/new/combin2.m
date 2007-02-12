function icnk = combin2 ( n, k )

%% COMBIN2 computes the binomial coefficient C(N,K).
%
%  Discussion:
%
%    The value is calculated in such a way as to avoid overflow and
%    roundoff.  The calculation is done in integer arithmetic.
%
%  Formula:
%
%    ICNK = C(N,K) = N! / ( K! * (N-K)! )
%
%  Modified:
%
%    09 June 2004
%
%  Reference:
%
%    M L Wolfson and H V Wright,
%    Combinatorial of M Things Taken N at a Time,
%    ACM algorithm 160,
%    Communications of the ACM,
%    April, 1963.
%
%  Parameters:
%
%    Input, integer N, K, are the values of N and K.
%
%    Output, integer ICNK, the number of combinations of N
%    things taken K at a time.
%
  mn = min ( k, n-k );

  if ( mn < 0 )

    icnk = 0;

  elseif ( mn == 0 )

    icnk = 1;

  else

    mx = max ( k, n-k );
    icnk = mx + 1;

    for ( i = 2 : mn )
      icnk = ( icnk * ( mx + i ) ) / i;
    end

  end
