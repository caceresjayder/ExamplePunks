// SPDX-license-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Base64.sol";
import './PunksDNA.sol';
import '@openzeppelin/contracts/utils/Strings.sol';




contract ExamplePunks is ERC721, ERC721Enumerable, Ownable, PunksDNA {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _tokenIdCounter;
    uint256 public maxSupply;
    mapping (uint256 => uint256) public tokenDNA;

    constructor(uint256 _maxSupply) ERC721("ExamplePunks", "EXP"){
        maxSupply = _maxSupply;
    }

    function safeMint() public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId < maxSupply, "Not Punks Left!");
        _tokenIdCounter.increment();
        tokenDNA[tokenId] = deterministicPseudoRandomDNA(tokenId, msg.sender);
        _safeMint(msg.sender, tokenId);
    }

    function _baseURI() internal pure override returns(string memory){
        return 'https://avataaars.io/';
    }

    function _paramsURI(uint256 _dna) internal view returns(string memory){
        string memory params;

        {
            params = string(
            abi.encodePacked(
                "accessoriesType=",
                getAccessoriesType(_dna),
                "&clotheColor=",
                getClotheColor(_dna),
                "&clotheType=",
                getClotheType(_dna),
                "&eyeType=",
                getEyeType(_dna),
                "&eyebrowType=",
                getEyeBrowType(_dna),
                "&facialHairColor=",
                getFacialHairColor(_dna),
                "&facialHairType=",
                getFacialHairType(_dna),
                "&hairColor=",
                getHairColor(_dna),
                "&hatColor=",
                getHatColor(_dna),
                "&graphicType=",
                getGraphicType(_dna),
                "&mouthType=",
                getMouthType(_dna),
                "&skinColor=",
                getSkinColor(_dna)
            )
        );
        }

        return string(abi.encodePacked(params, '&topType=',
                getTopType(_dna)));
    }

    function imageByDNA(uint256 _dna) public view returns (string memory){
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramsURI(_dna);

        return string(abi.encodePacked(baseURI,'?',paramsURI));
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory){
        require(_exists(tokenId), 'ERC721 Metadata: URI query for nonexistent token');

         uint256 dna = tokenDNA[tokenId];
        string memory image = imageByDNA(dna);

        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{ "name" : "ExamplePunks #',
                tokenId.toString(),
                '", "description" : "ExamplePunks are randomized Avatars stored on chain to develop a DAPP", "image": "',
                image,
                '"}'
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", jsonURI));
    }

    // override required
    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}