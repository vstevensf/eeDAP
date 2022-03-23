% GNU octave is a scientific programming language used for plotting and visualization tools
% It is also MATLAB compatible
function is = is_octave ()
is = exist ('OCTAVE_VERSION', 'builtin') == 5;
end
