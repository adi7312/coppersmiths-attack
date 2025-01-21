p = random_prime(2^512)
q = random_prime(2^512)
n = p * q
a = p - (p % 2 ^ 150)
print(hex(a))

X = 2^150
M = matrix( [[X^2, X*a,0], [0,X,a],[0,0,n]] )
M_LLL = M.LLL()

Q = M_LLL[0][0]*x^2/X^2+M_LLL[0][1]*x/X + M_LLL[0][2]
print(Q.roots(ring=ZZ))
print(a+Q.roots(ring=ZZ)[0][0] == p)
