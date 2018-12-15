g = graph;

a = [1 5 4 7 9];

g = addnode(g,20);

b = [3 1 7 10 15 20 18]

for r=1:length(a)
    g = addedge(g,2,a(r));
end

for r=1:length(b)
    g = addedge(g,4,b(r));
end
r = neighbors(g,4)
isempty (neighbors(r==5))
plot (g)