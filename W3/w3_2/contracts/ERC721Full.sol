// contracts/GameItem.sol
// SPDX-License-Identifier: MIT

//未跑通----待完善
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract GameItem is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // nft 名称 , nft 简写, nft基本地址
     constructor(
        string memory name, 
        string memory symbol,
        string memory baseURI
    ) ERC721(name, symbol) public {
        _baseURI(baseURI);
    }

    // 白名单player-你的地址
    // URI URL
    function awardItem(address player, string memory tokenURI)
        public
        returns (uint256)
    {   
        // tokenid 不可重复
        _tokenIds.increment();

        // 获取到自增侯的tokenid
        uint256 newItemId = _tokenIds.current();

        //铸造nft, 地址-tokenid
        _mint(player, newItemId);

        //设置token的相关信息
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }
}

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// //全功能ERC721代币
// contract ERC721Full is ERC721, ERC721Holder {
//     using Counters for Counters.Counter;
//     Counters.Counter private _tokenIds;

    // constructor(
    //     string memory name, //代币名称
    //     string memory symbol,//代币缩写
    //     string memory baseURI//代币基本地址
    // ) ERC721(name, symbol) public {
    //     _setBaseURI(baseURI);
    // }

//     function awardItem(address player, string memory tokenURI) public returns (uint256) {
//         _tokenIds.increment();

//         uint256 newItemId = _tokenIds.current();
//         _mint(player, newItemId);
//         _setTokenURI(newItemId, tokenURI);

//         return newItemId;
//     }
// }