function [E, itr] = Kepler(e, M, tol)
E = M;
max_iterations = 10;
for k = 1: max_iterations
    fEk = E - e*sin(E)-M;
    fEdk = 1 - e*cos(E) ; 
    E_k = E - (fEk/fEdk);
    if abs(E_k-E) < tol
        E = E_k;
        itr = k;
        break
    end
    E = E_k; 
end
fprintf('Converged after %d iterations\n', itr);
fprintf('Eccentric Anomaly (E) = %.8f radians\n', E);
end

