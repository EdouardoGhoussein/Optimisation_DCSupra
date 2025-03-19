%% Fonction contrainte de stabilité
function A = is_stable(I)
    D = zeros(length(I),1);
    for i=1:length(D)
        pas_de_moyennage = 250;
        a = fix(max(1, fix(i-pas_de_moyennage/2)));
        b = fix(min(length(D), fix(i+pas_de_moyennage/2)));
        moyenne_glissante = mean(I(a:b));
        D(i) = sqrt((I(i)-moyenne_glissante)^2) + moyenne_glissante;
    end
    Liste_result = D;
    longueur = length(Liste_result);
    pas_de_moyennage = 300;
    moyenne = zeros(1, longueur);
    maximum = zeros(1, longueur);
    for i=1:longueur
        a = fix(max(1, fix(i-pas_de_moyennage/2)));
        b = fix(min(longueur, fix(i+pas_de_moyennage/2)));
        moyenne_glissante = mean(Liste_result(a:b));
        moyenne(i) = moyenne_glissante;
        maximum(i) = max(Liste_result(a:b));
    end
    if maximum(length(maximum)-100) > maximum(6000)
        A = 1;
    else
        A = -1;
    end
end
